FactoryGirl.define do
  factory :primary_dev, class: Person  do
    name { FFaker::Name.first_name }
    roles ["primary_developer"]
  end

  factory :supplemental_dev, class: Person  do
    name { FFaker::Name.first_name }
    roles ["supplemental_developer"]
  end

  factory :infrastructure_dev, class: Person  do
    name { FFaker::Name.first_name }
    roles ["infrastructure_developer"]
  end

  factory :primary_and_supplemental_dev, class: Person  do
    name { FFaker::Name.first_name }
    roles ["primary_developer", "supplemental_developer"]
  end

  factory :week do
    start_date Date.new(2015,11,27)
  end

  factory :primary_dev_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :primary_dev
    role "primary_dev"
  end

  factory :supplemental_dev_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :supplemental_dev
    role "supplemental_dev"
  end

  factory :infrastructure_dev_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :infrastructure_dev
    role "infrastructure_dev"
  end
end
