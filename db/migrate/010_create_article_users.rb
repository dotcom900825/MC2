class CreateArticleUsers < ActiveRecord::Migration#文章与标签间的关系
  def self.up
    create_table :article_users do |t|
      t.integer "article_id"#content_id
      t.integer "user_id"#tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :article_users
  end
end
