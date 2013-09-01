class CreateResources < ActiveRecord::Migration#上传类资源
  def self.up
    create_table :resources do |t|
      t.integer  :size
      t.string   :upload
      t.string   :mime
      t.integer  :article_id
      t.boolean  :itunes_metadata
      t.string   :itunes_author
      t.string   :itunes_subtitle
      t.integer  :itunes_duration
      t.text     :itunes_summary
      t.string   :itunes_keywords
      t.string   :itunes_category
      t.boolean  :itunes_explicit
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
