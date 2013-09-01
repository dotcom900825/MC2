class Blog::CoauthorController < Blog::BaseController

  skip_before_filter :authorize, :only => [:index, :show]

  def create
    articleid=params[:id];
    users=params[:users] ;

    users.each do |user|
      Coauthor.create!(:article_id => articleid,:user_id => user.id);
    end
  end

  def delete
    articleid=params[:id];
    users=params[:users] ;
    users.each do |user|
      Coauthor.delete_all(["article_id=? AND user_id=?",articleid, user.id]);

    end

  end

  def getuserlist
    if request.post?
      page = params[:page] || 1
      if params[:search]
        conditions = "(name like '%%#{params[:search]}%%' or login like '%%#{params[:search]}%%')"
      else
        conditions = ""
      end
      users = User.paginate  :conditions=>[conditions],:page=> page, :per_page=> 10,:order => "id DESC"

      result = users.collect{|user| {:id=>user.id,:name=>user.name,:avatar=>user.picture_url}}
      # result = users.collect{|user| {:tag => user.name}}
      respond_to do |format|
        format.json{
          render :json => result.to_json
        }
      end
    end
  end

end