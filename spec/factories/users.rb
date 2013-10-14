FactoryGirl.define do
  factory :user do
    sequence(:email){ |n| "user_#{n}@scrapsapp.com" }
    sequence(:username){ |n| "user_#{n}" }
    first_name "John"
    last_name "Rambo"
    password "abc123"
    password_confirmation "abc123"
    confirmed_at { Time.now }
  end
end
