# coding: utf-8
class Admin::TagsController < Admin::BaseController

  def index
    page = params[:page] || 1
    @tags = Tag.paginate :page=> page, :per_page=> 6,:order => "display_name DESC"
  end


  def edit
    @tag = Tag.find(params[:id])
    @tag.attributes = params[:tag]
    if request.post?
      if @tag.save
        flash[:notice] = '标签已更新'
        redirect_to :action => 'index'
      end
    end
  end

  
  def destroy
    @record = Tag.find(params[:id])
    @record.article_tag.clear
    @record.destroy
    flash[:notice] = '标签已删除'
    redirect_to :action => 'index'
  end
  
end
