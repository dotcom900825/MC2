# coding: utf-8
class Admin::ProfilesController < Admin::BaseController


  def index
    page = params[:page] || 1
    @profiles = Profile.paginate :page=> page, :per_page=> 6
  end


  def new
    new_or_edit
  end
  

  def edit
    new_or_edit
  end
  

  def destroy
    @record = Profile.find(params[:id])
    if @record.id==1 or @record.id==2
      flash[:error] = "默认组无法删除"
    else
      @record.destroy
      flash[:notice] = "分组删除成功"
    end
    redirect_to :action => 'index'
  end
 

  private

  def new_or_edit
    @profile = case params[:id]
    when nil
      Profile.new
    else
      Profile.find(params[:id])
    end
    if request.post?
      if @profile.id==1 or @profile.id==2
        flash[:error] = "默认组无法修改"
      else
        @profile.attributes = params[:profile]
        @profile.modules = params[:modules]
        @profile.save
        set_the_flash
      end
      redirect_to :action => 'index'
    end
  end

  
  def set_the_flash
    case params[:action]
    when 'edit'
      flash[:notice] = '分组改成功'
    else 'new'
      flash[:notice] = '分组新建成功'
    end
  end


end
