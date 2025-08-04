puts "Clearing database..."
Comment.destroy_all
Attachment.destroy_all
TaskDependency.destroy_all
TaskTag.destroy_all
TaskAssignment.destroy_all
Task.destroy_all
Tag.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users..."
user1 = User.create!(name: "Alice", email: "alice@gmail.com", password: "123456")
user2 = User.create!(name: "Bob", email: "bob@gmail.com", password: "123456")

puts "Creating project..."
project = Project.create!(
    name: "Product X Launch",
    description: "Planning and execution of the launch campaign.",
    user_id: user1.id
    )

puts "Creating tags..."
tag_bug = Tag.create!(name: "bug")
tag_ui  = Tag.create!(name: "UI")

puts "Creating tasks..."
task1 = Task.create!(
  title: "Design layout",
  description: "Create UI prototype using Figma.",
  project_id: project.id,
  due_date: Date.today + 7.days,
  status: "pending",
  priority: "high"
)

task2 = Task.create!(
  title: "Fix login button",
  description: "Adjust alignment on mobile view.",
  project_id: project.id,
  due_date: Date.today + 2.days,
  status: "in progress",
  priority: "medium"
)

puts "Assigning users to tasks..."
TaskAssignment.create!(user_id: user1.id, task_id: task1.id, role: "Designer")
TaskAssignment.create!(user_id: user2.id, task_id: task2.id, role: "Frontend Developer")

puts "Tagging tasks..."
TaskTag.create!(task_id: task1.id, tag_id: tag_ui.id)
TaskTag.create!(task_id: task2.id, tag_id: tag_bug.id)

puts "Creating task dependency..."
TaskDependency.create!(task_id: task2.id, depends_on_task_id: task1.id)

puts "Adding comments..."
Comment.create!(
  task_id: task2.id,
  user_id: user2.id,
  content: "Partially fixed. Needs testing on Safari.",
  author_type: user2.name
)

puts "Attaching file..."
Attachment.create!(
  task_id: task1.id,
  file_url: "https://via.placeholder.com/150",
  file_type: "image/png"
)

puts "Seed completed successfully!"
