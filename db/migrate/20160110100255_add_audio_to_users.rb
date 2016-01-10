class AddAudioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :audio, :string
  end
end
