class CreateArticleTags < ActiveRecord::Migration#文章与标签间的关系
  def self.up
    create_table :article_tags do |t|
      t.integer "article_id"#content_id
      t.integer "tag_id"#tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :article_tags
  end
end
