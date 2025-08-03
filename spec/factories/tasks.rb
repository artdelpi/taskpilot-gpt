FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    project { nil }
    due_date { "2025-08-03" }
    status { "MyString" }
    priority { "MyString" }
  end
end
