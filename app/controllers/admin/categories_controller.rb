# coding: utf-8
class Admin::CategoriesController < Admin::BaseController


  def index
    page = params[:page] || 1
    @categories = Category.paginate :page=> page, :per_page=> 6,:order => "id DESC"
  end


  def new
    new_or_edit
  end
  

  def edit
    new_or_edit
  end
  

  def destroy
    @record = Category.find(params[:id])
    @record.destroy
    flash[:error] = "分类删除成功"
    redirect_to :action => 'index'
  end

  def child
    @parent_category=Category.find(params[:id])
    params[:id]=nil
    new_or_edit
  end


  private

  def new_or_edit
    page = params[:page] || 1
    @categories = Category.paginate :page=> page, :per_page=> 6,:order => "id DESC"
    @category = case params[:id]
    when nil
      Category.new
    else
      Category.find(params[:id])
    end
    if request.post?
      @category.attributes = params[:category]
      @category.parent_id = @parent_category.id if @parent_category
      @category.save
      set_the_flash
      redirect_to :action => 'index'
    end
  end

  
  def set_the_flash
    case params[:action]
    when 'edit'
      flash[:notice] = '分类修改成功'
    else 'new'
      flash[:notice] = '分类新建成功'
    end
  end


end
