class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :title
      t.references :article, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
