class CreateEdocs < ActiveRecord::Migration
  def change
    create_table :edocs do |t|
      t.integer :owner_id
      t.integer :source_id
      t.string :file_name, :limit => 64
      t.string :title, :limit => 64
      t.text :description, :limit => 2048
      t.string :website, :limit => 64
      t.string :language, :limit => 5
      t.string :timezone, :limit => 16
      t.string :schedule, :limit => 32
      t.integer :last_run
      t.integer :next_run
      t.text :log, :limit => 2048
      t.string :conversion, :limit => 128
      t.string :format, :limit => 4
      t.string :device, :limit => 16
      t.string :recipe_name, :limit => 64
      t.string :comment, :limit => 256
      t.integer :cost, :default => 0
      t.integer :computime
      t.boolean :requires_login
      t.boolean :is_mailed
      t.boolean :is_approved
      t.boolean :has_private_recipe
      t.boolean :has_error

      t.timestamps
    end

    add_index :edocs, :owner_id
    add_index :edocs, :source_id

  end
end