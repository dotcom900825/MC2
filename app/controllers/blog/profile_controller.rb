# coding: utf-8
class Blog::ProfileController < Blog::BaseController

  def index
    userid = current_user.id
  	@user = current_user
    @myarticles = Article.find(:all, :conditions=>["user_id like ? and parent_id like ?", userid, 0], :order => "id DESC")
    @isProfileActive = true
    
    @follows = current_user.article_user

    @contributes = Contribute.find_all_by_user_id(userid);

     # @user.attributes = params[:user]

     # @user.password = User.password_hash(params[:user][:password]) unless params[:user][:password].nil?

     # unless params[:picture].nil?
     #   @user.picture_url = uploadfile(params[:picture]).split("/public")[1]
     # end

     # if request.post? and @user.save
     #   current_user = @user
     #   flash[:notice] = '用户修改成功'
     # end
  end

  def edit
  	user = current_user
    if request.post?
      user.name = params[:user][:name] if params[:user][:name]
      user.attributes = params[:user]
      if params[:picture]
        user.picture_url = uploadfile(params[:picture],user.id).split("/public")[1]
      else
        if !user.picture_url
          user.picture_url = "/img/avatar.png"
        end
      end

    # @user.password = User.password_hash(params[:user][:password]) unless params[:user].nil?
      if user.save
        current_user = user
        # respond_to do |format|
        #   format.json { render :json => user.attributes }
        # end
        backlink = request.env["HTTP_REFERER"]
        if (backlink.include? "sessions/account")
          backlink = '/'
        end
        redirect_to backlink
      end
    end
  end

  def user
  	user_id = params[:id]
  	@user = current_user
    # @myarticles = Article.find(:all, :conditions=>["user_id like :userid and parent_id like :parentid", :userid => current_user.id, :parentid => 0],:order => "id DESC")
  	# if user_id == current_user.id
  	# 	render (:action => 'blog/profile/index')
  	# else
    @follows = current_user.article_user
    
	  @user2 = User.find_by_id(params[:id])
	  @user2articles = Article.find(:all, :conditions=>["user_id like :userid and parent_id like :parentid", :userid => user_id, :parentid => 0],:order => "id DESC")
  	#end
    @contributes = Contribute.find_all_by_user_id(user_id);
  end

  private

  def uploadfile(file,id)
    if !file.original_filename.empty?
      filename = getfilename(file.original_filename,id)
      filepath = "#{Rails.root.to_s}/public/pictures/avatars/#{filename}"
      File.open(filepath, "wb") do |f|
        f.write(file.read)
      end
      return filepath
    end
  end

  def getfilename(filename,id)
    if !id.nil?
      "avatar_#{id}" + filename[/\.[^\.]+$/]
    end
  end
end
