class CreateFeedbacks < ActiveRecord::Migration#文章评论
  def self.up
    create_table :feedbacks do |t|
      t.string :type
      t.string :title
      t.string :author
      t.text :body#评论正文
      t.text :excerpt
      t.integer :user_id#评论用户id
      t.string :guid
      t.integer :text_filter_id
      t.text :whiteboard
      t.integer :article_id#文章id
      t.string :email
      t.string :url
      t.string :ip,               :limit => 40#评论用户ip
      t.string :blog_name
      t.boolean :published,       :default => false#发布状态
      t.datetime :published_at#发布时间
      t.string :state#评论状态
      t.boolean :status_confirmed
      t.integer :parent_id,       :default => 0#父评论
      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
