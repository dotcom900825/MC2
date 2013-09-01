# coding: utf-8
class CreateProfiles < ActiveRecord::Migration#用户类型
  class Profile < ActiveRecord::Base
    attr_accessible :label, :modules
  end

  def self.up
    create_table :profiles do |t|
      t.string :label#用户类型：admin or publisher or contributor
      t.string :nicename
      t.text :modules#对应功能模块权限
      t.timestamps
    end
    Profile.create!(:label => "管理员", :modules => ["admin/articles", "admin/categories", "admin/feedbacks", "admin/tags", "admin/users", "admin/profiles", "admin/profile"])
    Profile.create!(:label => "发布员", :modules => ["admin/articles", "admin/feedbacks", "admin/profile"])
  end

  def self.down
    drop_table :profiles
  end
end
