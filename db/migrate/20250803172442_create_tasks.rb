class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.date :due_date
      t.string :status
      t.string :priority

      t.timestamps
    end
  end
end
