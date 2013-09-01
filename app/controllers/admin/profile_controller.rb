# coding: utf-8
class Blog::ProfileController < Blog::BaseController

  def index
    @user = current_user
    @user.attributes = params[:user]

    @user.password = User.password_hash(params[:user][:password]) unless params[:user].nil?

    unless params[:picture].nil?
      @user.picture_url = uploadfile(params[:picture]).split("/public")[1]
    end

    if request.post? and @user.save
      current_user = @user
      flash[:notice] = '用户修改成功'
    end
  end



  private

  def uploadfile(file)
    if !file.original_filename.empty?
      filename=getfilename(file.original_filename)
      filepath = "#{Rails.root.to_s}/public/pictures/#{filename}"
      File.open(filepath, "wb") do |f|
        f.write(file.read)
      end
      return filepath
    end
  end

  def getfilename(filename)
    if !filename.nil?
      Time.now.strftime("%Y_%m_%d_%H_%M_%S") + '_' + filename
    end
  end


end
