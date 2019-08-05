class ChangeTasksNameLimit30 < ActiveRecord::Migration[5.2]
  def up
  	change_column :tasks, :name, :string, limit: 30
  	add_index :tasks, :name, unique: true
  end

  def down
  	change_column :tasks, :name, :string
  end
end
