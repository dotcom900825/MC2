class CreateCoauthors < ActiveRecord::Migration#文章与标签间的关系
  def self.up
    create_table :coauthors do |t|
      t.integer "article_id"#content_id
      t.integer "user_id"#tag_id
      t.string "function" #贡献职务
      t.timestamps
    end
  end

  def self.down
    drop_table :coauthors
  end
end
