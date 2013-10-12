
FactoryGirl.define do
  factory :folder do
    sequence(:name){|n| "folder #{n}"}
    association(:organization)
  end
end
