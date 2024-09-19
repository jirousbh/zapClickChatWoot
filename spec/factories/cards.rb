FactoryBot.define do
  factory :card do
    title { "MyString" }
    description { "MyText" }
    color { "MyString" }
    label_id { 1 }
    conversation_id { 1 }
  end
end
