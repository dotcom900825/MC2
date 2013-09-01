class Tag < ActiveRecord::Base

  attr_accessible :name

  has_many :article_tag
  has_many :article, :through => :article_tag

  
end
