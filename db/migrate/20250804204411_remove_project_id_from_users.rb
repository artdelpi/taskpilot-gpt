class RemoveProjectIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :project_id, :integer
  end
end
