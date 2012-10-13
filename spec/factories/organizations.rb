# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "Some Name #{n}"
  end

  factory :organization do
    name 
  end
end
