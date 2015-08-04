class AddColumnToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :ent_type, :string
  end
end
