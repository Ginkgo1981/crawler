class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :name
      t.string :url
      t.integer :weight, default: 0
      t.string :analyzer
      t.timestamps
    end
  end
end
