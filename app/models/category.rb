class Category < ActiveRecord::Base

  attr_accessible :name, :keywords, :description

  has_many :article

end

