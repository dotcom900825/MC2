# coding: utf-8
class Admin::ArticlesController < Admin::BaseController

  def index
    page = params[:page] || 1
    if params[:search]
      conditions = "(title like '%%#{params[:search][:searchstring]}%%' or body like '%%#{params[:search][:searchstring]}%%')"
      conditions << " and published = #{params[:search][:published]}" if params[:search][:published]!=""
      conditions << " and category_id = #{params[:search][:category_id]}" if params[:search][:category_id]!=""
      conditions << " and user_id = #{params[:search][:user_id]}" if params[:search][:user_id]!=""
      conditions << " and published_at like '%%#{params[:search][:published_at]}%%'" if params[:search][:published_at]!=""
    else
      conditions = ""
    end
    @articles = Article.paginate :conditions=>[conditions],:page=> page, :per_page=> 6,:order => "id DESC"
  end


  def new
    new_or_edit
  end


  def edit
    @article = Article.find(params[:id])
    @keywords=@article.tag.collect{|item| item.name}.join "，"
    unless @article.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to :action => 'index')
    end
    new_or_edit
  end

  
  def destroy
    @record = Article.find(params[:id])
    unless @record.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to :action => 'index')
    end
    @record.destroy
    flash[:notice] = "文章删除成功"
    redirect_to :action => 'index'
  end
  

  def child
    @parent_article=Article.find(params[:id])
    params[:id]=nil
    new_or_edit
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
      @article.published = false if params[:draft]
      @article.parent_id = @parent_article.id if @parent_article
      @article.user_id=current_user.id
      @article.author=current_user.login
      @article.published_at = Time.now
      if @article.save
        @article.article_tag.clear
        build_the_tags     
        set_the_flash
        redirect_to :action => 'index'
      end
    end
  end


  def build_the_tags
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
