class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.integer :industry_id
      t.string  :industry_name
      t.string  :title
      t.string  :sub_title
      t.text  :content
      t.timestamps
    end
  end
end
