class RemoveLinksFromResource < ActiveRecord::Migration
  def change
    remove_column :resources, :links, :string
  end
end
