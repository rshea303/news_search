class AddMoreFieldsToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :type, :string
    add_column :entities, :sent_score, :decimal
    add_column :entities, :sent_type, :string
  end
end
