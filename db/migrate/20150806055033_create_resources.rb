class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
