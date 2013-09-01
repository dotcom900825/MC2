class Coauthor < ActiveRecord::Base

  attr_accessible :article_id, :user_id ,:function

  belongs_to :article
  belongs_to :user

end