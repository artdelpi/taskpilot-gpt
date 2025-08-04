FactoryBot.define do
  factory :task_dependency do
    task { nil }
    depends_on_task_id { 1 }
  end
end
