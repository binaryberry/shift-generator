FactoryGirl.define do
  factory :primary_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["primary_developer"]
  end

  factory :supplemental_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["supplemental_developer"]
  end

  factory :infrastructure_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["infrastructure_developer"]
  end

  factory :oncall_weekday_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["oncall_weekday"]
  end

  factory :oncall_weekend_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["oncall_weekend"]
  end

  factory :primary_and_supplemental_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
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

  factory :oncall_weekday_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :infrastructure_dev
    role "infrastructure_dev"
  end

  factory :oncall_weekend_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :infrastructure_dev
    role "infrastructure_dev"
  end
end
