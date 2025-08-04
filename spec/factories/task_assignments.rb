FactoryBot.define do
  factory :task_assignment do
    user { nil }
    task { nil }
    role { "MyString" }
  end
end
