# coding: utf-8
class Admin::UsersController < Admin::BaseController

  def index
    page = params[:page] || 1
    @users = User.paginate :page=> page, :per_page=> 10,:order => "login ASC"
  end

  def new
    @user = User.new
    if request.post?
      if User.find_by_login(params[:user][:login])
        flash[:error] = "用户名已被注册"
        return(redirect_to :action => 'index')
      end
      @user.attributes = params[:user]
      @user.password = User.password_hash(params[:user][:password])
      @user.name = @user.login
      if @user.save
        flash[:notice] = '用户创建成功'
        redirect_to :action => 'index'
      end
    end
  end

  def edit
    @user = params[:id] ? User.find_by_id(params[:id]) : current_user
    @user.attributes = params[:user]
    @user.password = User.password_hash(params[:user][:password]) if params[:user]
    if request.post? and @user.save
      if @user.id == current_user.id
        current_user = @user
      end
      flash[:notice] = '用户修改成功'
      redirect_to :action => 'index'
    end
  end

  def destroy
    @record = User.find(params[:id])
    if @record.id==1
      flash[:error] = "默认管理员无法删除"
    else
      @record.destroy
      flash[:notice] = '用户删除成功'
    end
    redirect_to :action => 'index'
  end

  
end
