class CreateResourcesTags < ActiveRecord::Migration
  def change
    create_table :resources_tags do |t|
      t.integer :resource_id
      t.integer :tag_id
    end
  end
end
