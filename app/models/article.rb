class Article < ActiveRecord::Base

  attr_accessible :title, :excerpt, :body, :published, :allow_comments, :category_id

  belongs_to :user
  belongs_to :category
  has_many :coauthor
  has_many :contribute

  has_many :feedback, :order => "created_at DESC"
  has_many :article_tag
  has_many :article_user
  has_many :tag, :through => :article_tag
  has_many :user, :through=> :article_user
  has_many :user, :through=> :coauthor
  has_many :user, :through=> :contribute

  def access_by?(user)
    user.admin? || user_id == user.id
  end


  def self.find_by_published_at
    result = select('published_at').where('published_at is not NULL').where(type 'Article')
    result.map{ |d| [d.published_at.strftime('%Y-%m')]}.uniq
  end

  
  def self.get_or_build_article(id)
    return Article.find(id) if id.present?
    article = Article.new
  end
 
  

end
