class AddBelongsToCategoryToHelpsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :helps, :category_id
    add_reference :helps, :category, index: true
  end
end
