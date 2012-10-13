# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scrap do
    title { generate(:name) }
    description "MyText"
    user 
    organization 
    is_public true
  end
end
