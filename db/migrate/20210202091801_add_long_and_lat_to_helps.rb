class AddLongAndLatToHelps < ActiveRecord::Migration[6.0]
  def change
    add_column :helps, :lat, :float
    add_column :helps, :long, :float
  end
end
