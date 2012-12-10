# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :target do
    name "MyString"
    email "MyString"
    phone_number "MyString"
    priority false
  end
end
