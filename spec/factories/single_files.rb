# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :single_file do
    name "test.rb"
    content "MyText"
  end
end
