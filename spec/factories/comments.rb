FactoryBot.define do
  factory :comment do
    task { nil }
    user { nil }
    content { "MyString" }
    author_type { "MyString" }
  end
end
