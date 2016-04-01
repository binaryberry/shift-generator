FactoryGirl.define do
  factory :primary_developer, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["primary_developer"]
  end

  factory :supplemental_developer, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["supplemental_developer"]
  end

  factory :infrastructure_developer, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["infrastructure_developer"]
  end

  factory :oncall_weekday_developer, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["oncall_weekday_developer"]
  end

  factory :oncall_weekend_developer, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["oncall_weekend_developer"]
  end

  factory :primary_and_supplemental_dev, class: Person  do
    sequence(:name) {|n| FFaker::Name.first_name + " (#{n})"}
    roles ["primary_developer", "supplemental_developer"]
  end

  factory :week do
    start_date Date.new(2015,11,27)
  end

  factory :primary_developer_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :primary_developer
    role "primary_developer"
  end

  factory :supplemental_developer_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :supplemental_developer
    role "supplemental_developer"
  end

  factory :infrastructure_developer_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :infrastructure_developer
    role "infrastructure_developer"
  end

  factory :oncall_weekday_developer_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :oncall_weekday_developer
    role "oncall_weekday_developer"
  end

  factory :oncall_weekend_developer_assignment, class: Assignment do
    association :week, factory: :week
    association :person, factory: :oncall_weekend_developer
    role "oncall_weekend_developer"
  end
end
