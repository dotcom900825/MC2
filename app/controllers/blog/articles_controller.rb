# coding: utf-8
class Blog::ArticlesController < Blog::BaseController
  skip_before_filter :authorize, :only => [:feed, :show]

  def index
    page = params[:page] || 1
    @myarticles = Article.find(:all,:conditions=>["user_id = ? and parent_id = ?", current_user.id, 0])
    @isHomeActive = true

    if params[:tag]
      tag = Tag.find_by_name(params[:tag]);
      if tag
        @articles = tag.article
      else
        @articles = []
      end
      return
    end

    if params[:search]
      conditions = "(title like '%%#{params[:search][:searchstring]}%%' or body like '%%#{params[:search][:searchstring]}%%') and parent_id =0"
      conditions << " and category_id = #{params[:search][:category_id]}" if params[:search][:category_id]
      @search = params[:search][:searchstring]
    else
      conditions = "parent_id = 0"
    end    
    @articles = Article.paginate :conditions=>[conditions],:page=> page, :per_page=> 12,:order => "id DESC"
  end

  def myarticles
    page = params[:page] || 1
    @articles = Article.paginate :conditions=>["user_id = ?", current_user.id],:page=> page, :per_page=> 10,:order => "id DESC"
  end

  def myfollow
    userid = session[:user_id];
    articleusers = ArticleUser.find(:all, :conditions=>["user_id=?",userid] ,:order => "id DESC" );
    @articles=[];
    articleusers.each do |articleuser|
      @articles << Article.find(articleuser.article_id);
    end
    @myarticles = Article.find(:all,:conditions=>["user_id = ? and parent_id = ?", userid, 0])
    @isMyFollowActive = true
  end

  def feed
    userid = session[:user_id]
    @article = Article.find(params[:id])
    @parent_article = Article.find(@article.parent_id)
    @isAuthor = (userid == @article.user_id)
    @feedreply = @article.feedback
  end

  def new
    new_or_edit
  end

  def show
    id = params[:id]
    userid=session[:user_id];

    @article = Article.find(id)
    @keywords = @article.tag.collect{|item| item.name}[0].split(",") if !@article.tag.blank?
    @feeds = Article.find(:all, :conditions=>["parent_id = ?",id],:order => "id DESC")
    @feedbacks = @article.feedback
    #@follower = ArticleUser.find_all_by_article_id(id)
    @follower=ArticleUser.find(:all,:conditions=>["article_id=?",id],:order => "id DESC");
    
    coauthor_ids = Coauthor.find_all_by_article_id(id)
    @coauthors = []
    coauthor_ids.each do |coauthor|
      @coauthors << User.find(coauthor.user_id)
    end

    @contributors = Contribute.find_all_by_article_id(id);

    result = ArticleUser.find(:all,:conditions=>['article_id=? AND user_id=?',id,userid]);
    if result==[]
      @status=0;
    else
      @status=1;
    end

    new_or_edit
  end
  
  def edit
    id = session[:id]
    articleid = params[:id]

    @article = Article.find(params[:id])
    @keywords = @article.tag.collect{|item| item.name}.join ","

    coauthor_ids = Coauthor.find_all_by_article_id(articleid)
    @coauthors = []
    coauthor_ids.each do |coauthor|
      @coauthors << User.find(coauthor.user_id)
    end


    unless @article.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to :action => 'index')
    end


    new_or_edit
  end

  def follow
    articleid=params[:id];
    userid=session[:user_id];

    result=ArticleUser.find(:all,:conditions=>['article_id=? AND user_id=?',articleid,userid]);
    if result==[]
      ArticleUser.create!(:article_id => articleid,:user_id => userid);
      followed = true
    else
      ArticleUser.delete_all(["article_id=? AND user_id=?",articleid, userid]);
      followed = false
    end
    count = ArticleUser.find( :all,:conditions=>['article_id=?',articleid]).length

    respond = {:followed => followed, :count => count}

    respond_to do |format|
      format.json{
        render :json => respond.to_json
      }
    end
  end

  def getmoreproject
    page = params[:page] || 1
    articles = Article.paginate :conditions=>["parent_id = 0"],:page=> page, :per_page=> 12,:order => "id DESC"
    # result = {:articles => articles}
    result = {:articles => articles.collect{|article| {:name => article.name,:id=>article.id,:src=>article.picture_url,:follow=>article.article_user.count,:category=>Category.find(article.category_id).name}}}
    respond_to do |format|
      format.json{
        render :json => result.to_json
      }
    end
  end

  def gettaglist
    search = params[:search]
    tags = Tag.where('name LIKE ? ', "%#{search}%")
    respond = tags.collect{|tag| {:tag => tag.name}}
    respond_to do |format|
      format.json{
        render :json => respond.to_json
      }
    end
  end

  protected

  def new_or_edit
    id = params[:id]
    id = params[:article][:id] if params[:article] && params[:article][:id]
    @article = Article.get_or_build_article(id)
    if request.post?
      @article.attributes = params[:article]
      @article.body = params[:body]
      unless params[:picture].nil?
        @article.picture_url = uploadfile(params[:picture]).split("/public")[1]
      end
      @article.published = false if params[:published]
      @article.parent_id = params[:parent_id] if params[:parent_id]
      @article.user_id = current_user.id
      @article.author = current_user.login
      @article.published_at = Time.now
      if @article.save
        @article.article_tag.clear
        build_the_tags
        # set_the_flash
        
        articleid = @article.id
        users = params[:users].split(",") ;
        users.each do |user|
          if  Coauthor.find(:all,:conditions=>['article_id=? AND user_id=?',articleid,user])
            Coauthor.delete_all(["article_id=? AND user_id=?",articleid, user]);
          end
        end
        users.each do |user|
          Coauthor.create!(:article_id => articleid,:user_id => user);
        end
	
      	if params[:article][:category_id] == "8"
          Contribute.create!(:article_id => @article.parent_id, :user_id => users[0] , :feed_id => articleid );
      	end

        if params[:parent_id]
          redirect_url = "/blog/articles/feed/#{articleid}"
        else 
          redirect_url = "/blog/articles/show/#{articleid}"
        end
        redirect_to redirect_url
      end
    end
  end

  def build_the_tags
    if params[:keywords]
      tags=params[:keywords].split("，")
      tags.each do |tag|
        record=Tag.where('name LIKE ? ', "%#{tag}%")
        if record!=[]
          ArticleTag.create!(:article_id => @article.id,:tag_id => record.first.id)
        else
          ArticleTag.create!(:article_id => @article.id,:tag_id => Tag.create!(:name => tag).id)
        end
      end
    end
  end


  def set_the_flash
    case params[:action]
    when 'edit'
      flash[:notice] = '文章修改成功'
    else 'new'
      flash[:notice] = '文章新建成功'
    end
  end

  private

  def uploadfile(file)
    if !file.original_filename.empty?
      filename=getfilename(file.original_filename)
      filepath = "#{Rails.root.to_s}/public/pictures/#{filename}"
      File.open(filepath, "wb") do |f|
        f.write(file.read)
      end
      return filepath
    end
  end

  def getfilename(filename)
    if !filename.nil?
      Time.now.strftime("%Y_%m_%d_%H_%M_%S") + '_' + filename
    end
  end

 
end
