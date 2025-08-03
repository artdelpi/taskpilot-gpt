class CreateTaskDependencies < ActiveRecord::Migration[8.0]
  def change
    create_table :task_dependencies do |t|
      t.references :task, null: false, foreign_key: true
      t.integer :depends_on_task_id

      t.timestamps
    end
  end
end
