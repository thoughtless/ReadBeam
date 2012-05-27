class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :account_email, :null => false, :limit => 64
      t.string :device_email, :limit => 64
      t.string :device, :limit => 16
      t.string :format, :null => false, :limit => 4
      t.string :timezone, :limit => 16
      t.string :username, :limit => 16
      t.integer :computime, :default => 0
      t.integer :credit, :default => 0
      t.boolean :is_admin

      #t.timestamps
    end    
  end
end