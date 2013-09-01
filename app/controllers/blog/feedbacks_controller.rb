# coding: utf-8
class Blog::FeedbacksController < Blog::BaseController

  def new
    new_or_edit
  end
  
  def edit
    @feedback = Feedback.find(params[:id])
    unless @feedback.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to "/blog/articles/show/#{params[:article_id]}")
    end
    new_or_edit
  end

 
  def destroy
    @record = Feedback.find params[:id]
    unless @record.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to "/blog/articles/show/#{params[:article_id]}")
    end    
    @record.destroy
    flash[:notice] = "评论删除成功"
    redirect_to "/blog/articles/show/#{params[:article_id]}"
  end
 

  protected

  def new_or_edit
    @feedback = case params[:id]
    when nil
      Feedback.new
    else
      Feedback.find(params[:id])
    end
    if request.post?
      @feedback.body = params[:body]
      @feedback.article_id = params[:article_id]
      @feedback.user_id = current_user.id
      @feedback.author = current_user.login
      @feedback.published_at = Time.now
      @feedback.save
      # set_the_flash
      redirect_to request.env["HTTP_REFERER"]  
      # redirect_to "/blog/articles/show/#{}"
    end  
  end


  def set_the_flash
    case params[:action]
    when 'edit'
      flash[:notice] = '评论修改成功'
    else 'new'
      flash[:notice] = '评论发布成功'
    end
  end
 

  
end
