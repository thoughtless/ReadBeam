class RemoveLastRunFromEdocs < ActiveRecord::Migration
  def up
    remove_column :edocs, :last_run
  end

  def down
    add_column :edocs, :last_run, :integer
  end
end
