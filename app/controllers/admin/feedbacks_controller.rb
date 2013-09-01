# coding: utf-8
class Admin::FeedbacksController < Admin::BaseController


  def index
    page = params[:page] || 1
    @search = params[:search] ? params[:search] : ""
    @feedbacks = Feedback.paginate :conditions=>["body like ?","%#{@search}%"], :page=> page, :per_page=> 6,:order => "created_at DESC"
  end


  def new
    new_or_edit
  end

  
  def edit
    @feedback = Feedback.find(params[:id])
    @article = @feedback.article
    unless @feedback.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to :action => 'index')
    end
    new_or_edit
  end

 
  def destroy
    @record = Feedback.find params[:id]
    unless @record.access_by?(current_user)
      flash[:error] = "错误，不允许进行此操作"
      return(redirect_to :action => 'index')
    end    
    @record.destroy
    flash[:notice] = "评论删除成功"
    redirect_to :action => 'index'
  end

  
  def article
    page = params[:page] || 1
    @article = Article.find(params[:id])
    @feedbacks = Feedback.paginate :conditions=>["article_id = ?",@article.id], :page=> page, :per_page=> 6
    @feedback=Feedback.new
  end

  def child
    @parent_feedback=Feedback.find(params[:id])
    @article = @parent_feedback.article
    params[:id]=nil
    new_or_edit
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
      @feedback.attributes = params[:feedback]
      @feedback.body = params[:body]
      @feedback.parent_id = @parent_feedback.id if @parent_feedback
      @feedback.user_id=current_user.id
      @feedback.author=current_user.login
      @feedback.published_at = Time.now
      @feedback.save
      set_the_flash     
      redirect_to :action => 'index'
    end  
  end


  def set_the_flash
    case params[:action]
    when 'edit'
      flash[:notice] = '评论修改成功'
    else 'new'
      flash[:notice] = '评论新建成功'
    end
  end
 

  
end
