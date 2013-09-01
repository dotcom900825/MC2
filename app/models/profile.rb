class Profile < ActiveRecord::Base

  attr_accessible :label, :modules

  has_many :user
  serialize :modules
  validates_uniqueness_of :label
 
  ADMIN = 'admin'
  PUBLISHER = 'publisher'

 
end
