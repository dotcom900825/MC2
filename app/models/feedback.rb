class Feedback < ActiveRecord::Base

  attr_accessible :title, :body, :article_id

  belongs_to :user
  belongs_to :article

  def access_by?(user)
    user.admin? || user_id == user.id
  end
  
end
