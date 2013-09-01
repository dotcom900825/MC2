# coding: utf-8
class SessionsController < ApplicationController
  def account
    if logged_in?
      redirect_to '/'
    end
  end

  def login
    # if session[:user_id] && session[:user_id] == self.current_user.id
    #   redirect_back_or_default :controller => "blog/articles", :action => "index"
    #   return
    # end
    if request.post?
      self.current_user = User.authenticate(params[:user][:login], params[:user][:password])
      if logged_in?
        session[:user_id] = self.current_user.id
        # flash[:notice]  = "登录成功"
        # redirect_to "/blog/articles/index"
        render :text => true
      else
        # flash[:error]  = "登录失败"
        # @login = params[:user][:login]
        # respond_to do |format|
        #   format.json { render :json => false }
        # end
        render :text => false
      end
    end
  end


  def signup
    user = User.new
    if request.post?
      if User.find_by_login(params[:user][:login])
        # flash[:error] = "用户名已被注册"
        # return(redirect_to :action => 'account')
        respond_to do |format|
          format.json { render :json => false }
        end
        return
      end
      user.name = "#{params[:user][:firstname]}#{params[:user][:secondname]}"
      user.attributes = params[:user]
  #    @user.login=@user.email
      user.password = User.password_hash(params[:user][:password])
 #     @user.name = @user.login
      user.profile_id = 2
      user.state = "active"
      if user.save
        session[:user_id] = user.id
        self.current_user = user
        render :text => user.attributes
        # flash[:notice]  = "请通过邮箱激活帐号"
        # UserMailer.registration_confirmation(user).deliver
        # redirect_to "/blog/articles/index"
        # return
      else
        render :text => "canot save"
      end
    end
  end


  def activity
    user=User.where("id = ? AND state = ?", params[:id], 'inactive').first
    if user
      user.state="active"
      if user.save
        self.current_user = user
        session[:user_id] = user.id
        flash[:notice]  = "欢迎来到blog的世界"
        redirect_to "/blog/articles/index"
      end
    else
      flash[:error]  = "错误的激活信息"
      redirect_to :controller => "sessions", :action => "signup"
    end
  end


  def logout
    flash[:notice]  ="成功退出"
    self.current_user = nil
    session[:user_id] = nil
    cookies.delete :auth_token
    cookies.delete :typo_user_profile
    redirect_to "/blog/articles/index"
  end
  
end
