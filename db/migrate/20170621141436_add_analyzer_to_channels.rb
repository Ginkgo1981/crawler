class AddAnalyzerToChannels < ActiveRecord::Migration[5.0]
  def change
    add_column :channels, :analyzer, :string
  end
end
