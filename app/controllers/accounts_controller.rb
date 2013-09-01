# coding: utf-8
class AccountsController < ApplicationController  

  def login
    if session[:user_id] && session[:user_id] == self.current_user.id
      redirect_back_or_default :controller => "admin/articles", :action => "index"
      return
    end
    if request.post?
      self.current_user = User.authenticate(params[:user][:login], params[:user][:password])
      if logged_in?
        session[:user_id] = self.current_user.id
        flash[:notice]  = "登录成功"
        redirect_to "/#{current_user.profile.modules.first}"
      else
        flash[:error]  = "用户名或密码错误"
        redirect_to :action => 'login'
      end
    end
  end


  def logout
    flash[:notice]  ="成功退出"
    self.current_user = nil
    session[:user_id] = nil
    cookies.delete :auth_token
    cookies.delete :typo_user_profile
    redirect_to :action => 'login'
  end



end
