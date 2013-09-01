class ApplicationController < ActionController::Base
  include ::LoginSystem
  #  before_filter :set_i18n_local_from_params
  protect_from_forgery


  def add_to_cookies(name, value, path=nil, expires=nil)
    cookies[name] = { :value => value, :path => path || "/#{controller_name}", :expires => 6.weeks.from_now }
  end

  protected

  def set_i18n_local_from_params
    

  end

  
end
