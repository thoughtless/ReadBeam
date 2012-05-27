class RemoveLogFromEdocs < ActiveRecord::Migration
  def up
    remove_column :edocs, :log
  end

  def down
    add_column :edocs, :log, :text
  end
end
