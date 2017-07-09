class CreateInterestTags < ActiveRecord::Migration[5.0]
  def change
    create_table :interest_tags do |t|
      t.string :intent
      t.string :name
      t.timestamps
    end
  end
end
