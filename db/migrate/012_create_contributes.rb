class CreateContributes < ActiveRecord::Migration#文章与标签间的关系
  def self.up
    create_table :contributes do |t|
      t.integer "article_id"#content_id
      t.integer "user_id"#tag_id
      t.integer "feed_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :contributes
  end
end
