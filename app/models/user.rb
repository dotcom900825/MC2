require 'digest/sha1'

class User < ActiveRecord::Base
  

  attr_accessible :login, :password, :email, :name,  :state, :profile_id  , :picture_url ,:education ,:position ,:tel ,:qq ,:sinaweibo ,:tecentweibo ,:renren
  has_many :article
  has_many :feedback
  has_many :article_user
  has_many :coauthor
  has_many :contribute

  has_many :article, :through => :article_user
  has_many :article, :through=> :coauthor
  has_many :article, :through=> :contribute

  
  belongs_to :profile


  class_attribute :salt

  def self.salt
    '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
  end


  def admin?
    profile.id == 1
  end


  def self.authenticate(login, pass)
    where("login = ? AND password = ? AND state = ?", login, password_hash(pass), 'active').first
  end

  def project_modules
    profile.project_modules
  end

  protected
  
  def self.password_hash(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end

  def password_hash(pass)
    self.class.password_hash(pass)
  end


  
end
