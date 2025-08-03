class RemoveUserIdFromProjects < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :user_id, :integer
  end
end
