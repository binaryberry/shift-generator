FactoryGirl.define do
  factory :person do
    name "bob"
    roles ["primary_dev"]
  end

  factory :week do
    start_date Date.new(2015,11,27)
  end

  factory :supplemental_dev_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :person
    role "supplemental_dev"
  end

  factory :primary_dev_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :bob
    role "primary_dev"
  end
end
