# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :observer do
    user nil
    organization nil
    membership nil
  end
end
