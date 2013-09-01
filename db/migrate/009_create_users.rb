class CreateUsers < ActiveRecord::Migration#用户信息
  class User < ActiveRecord::Base
    attr_accessible :login, :password, :email, :name, :profile_id  , :picture_url ,:education ,:position ,:tel ,:qq ,:sinaweibo ,:tecentweibo ,:renren
  end
  
  def self.up
    create_table :users do |t|
      t.string :login#用户登录名
      t.string :password#用户密码
      t.text :email#用户邮箱
      t.text :name#用户名
      t.boolean :notify_via_email
      t.boolean :notify_on_new_articles
      t.boolean :notify_on_comments
      t.integer :profile_id#用户类型(profile)id：admin or publisher or contributor
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :text_filter_id,            :default => "1"
      t.string :state,                     :default => "active"#用户活跃性
      t.datetime :last_connection#用户最后登录时间
      t.text :settings#用户设置内容
      t.string   :picture_url
      t.string  :education
      t.string  :position
      t.string  :tel
      t.string  :qq
      t.string  :sinaweibo
      t.string  :tecentweibo
      t.string  :renren


      t.timestamps
    end
    User.create!(:login => "admin", :password => "652b1b54a914207f0cfd15de1967d8ebe26c1b94",:name => "admin",:profile_id => 1)
  end

  def self.down
    drop_table :users
  end
end
