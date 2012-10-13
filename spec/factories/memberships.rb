# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :membership do
    user nil
    organization nil
    membership_type "MyString"
  end
end
