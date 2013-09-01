# coding: utf-8
class HomeController < ApplicationController
  
  def index
	if session[:user_id]
          redirect_to "/blog/articles/index"
       end    

#     if session[:user_id] && session[:user_id] == self.current_user.id
#          redirect_back_or_default :controller => "blog/articles", :action => "index"
#      return
#    end
  


    end

end
