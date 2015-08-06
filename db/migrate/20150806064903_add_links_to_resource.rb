class AddLinksToResource < ActiveRecord::Migration
  def change
    add_column :resources, :links, :text
  end
end
