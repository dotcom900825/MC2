class CreateCategories < ActiveRecord::Migration#文章类型
  def self.up
    create_table :categories do |t|
      t.string :name#类型名
      t.integer :position
      t.string :permalink
      t.text :keywords#类型关键词
      t.text :description#类型描述
      t.integer :parent_id,      :default => 0#父类型
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
