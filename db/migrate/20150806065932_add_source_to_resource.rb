class AddSourceToResource < ActiveRecord::Migration
  def change
    add_column :resources, :source, :string
  end
end
