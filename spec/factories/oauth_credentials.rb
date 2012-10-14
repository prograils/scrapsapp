# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :oauth_credential do
    provider "MyString"
    uid "MyString"
    params "MyText"
    user nil
  end
end
