# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "user_#{n}@scrappapp.com"
  end
  sequence :username do |n|
    "user_#{n}"
  end
  factory :user do
    email
    username 
    first_name "John"
    last_name "Rambo"
    password "StrongOne!"
    password_confirmation "StrongOne!"
  end
end