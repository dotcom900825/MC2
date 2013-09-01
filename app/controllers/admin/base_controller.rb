# coding: utf-8
class Admin::BaseController < ApplicationController
  layout 'administration'
  before_filter :authorize
  

  protected

  def authorize
    if session[:user_id]
      unless current_user.profile.modules.include?("admin/#{controller_name}")
        flash[:notice] = "没有访问权限"
        redirect_to "/#{current_user.profile.modules.first}"
      end
    else
      flash[:notice] = "请先登录"
      redirect_to "/admin"
    end
  end
end
