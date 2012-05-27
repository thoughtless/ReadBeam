class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :title
      t.text :description
      t.string :website
      t.string :language
      t.string :timezone
      t.string :schedule
      t.string :conversion
      t.string :recipe_name
      t.integer :cost, :default => 0
      t.boolean :requires_login

      t.timestamps
    end

    add_index :sources, :recipe_name

  end
end