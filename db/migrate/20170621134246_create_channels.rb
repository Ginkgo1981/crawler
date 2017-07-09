class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.integer :site_id
      t.string :name
      t.string :url
      t.string :status
      t.datetime :last_crawl_at
      t.timestamps
    end
  end
end
