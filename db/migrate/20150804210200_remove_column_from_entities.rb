class RemoveColumnFromEntities < ActiveRecord::Migration
  def change
    remove_column :entities, :type, :string
  end
end
