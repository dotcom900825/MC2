class CreateArticles < ActiveRecord::Migration#文章内容
  def self.up
    create_table :articles do |t|
      t.string   :type#内容类型
      t.string   :title#内容标题
      t.string   :author#内容作者
      t.text     :body#内容正文
      t.text     :extended
      t.text     :excerpt#内容摘要     
      t.integer  :user_id#发布用户id
      t.integer  :category_id#类型id
      t.string   :permalink
      t.string   :guid
      t.integer  :text_filter_id
      t.text     :whiteboard
      t.string   :name
      t.boolean  :published,      :default => false#发布状态
      t.boolean  :allow_pings
      t.boolean  :allow_comments
      t.datetime :published_at#发布时间
      t.string   :state#内容状态
      t.integer  :parent_id,      :default => 0#父内容
      t.text     :settings
      t.string   :post_type,      :default => :read
      t.string   :picture_url
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
