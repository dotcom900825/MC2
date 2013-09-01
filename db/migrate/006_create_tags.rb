class CreateTags < ActiveRecord::Migration#标签
  def self.up
    create_table :tags do |t|
      t.string   "name"#标签小写
      t.string   "display_name"#标签原型
      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
