# coding: utf-8
class Blog::BaseController < ApplicationController
  layout 'blog'
  before_filter :authorize
  

  protected

  def authorize
    unless session[:user_id]
      flash[:notice] = "请先登录"
      redirect_to "/sessions/account"
    end
  end
end
