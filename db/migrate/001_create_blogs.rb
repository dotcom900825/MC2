class CreateBlogs < ActiveRecord::Migration#blog信息
  def self.up
    create_table :blogs do |t|
      t.text :settings#blog基本设置信息
      t.string :base_url
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
