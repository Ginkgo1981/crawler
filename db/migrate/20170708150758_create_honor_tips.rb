class CreateHonorTips < ActiveRecord::Migration[5.0]
  def change
    create_table :honor_tips do |t|
      t.string :name
      t.text :tips
      t.timestamps
    end
  end
end
