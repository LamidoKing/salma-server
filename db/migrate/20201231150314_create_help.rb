class CreateHelp < ActiveRecord::Migration[6.0]
  def change
    create_table :helps do |t|
      t.string :title
      t.text :description
      t.integer :category_id
      t.belongs_to :user
      t.string :location
      t.integer :fulfilment_count, default: 0
      t.boolean :status, default: 0
      t.timestamps
    end
  end
end
