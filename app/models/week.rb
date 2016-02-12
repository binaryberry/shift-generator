require 'date'

class Week < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments, allow_destroy: true
  validates :start_date, presence: true, uniqueness:true
  validates_each :start_date do |record, attr, value|
    record.errors.add(attr, 'week must start on a Wednesday') if value && value.wednesday? == false
  end
  validates_each :assignments do |record, attr, _value|
    Week.roles.each do |r|
      record.errors.add(attr, 'only one role per week') if record.assignments.exists?(role: r)
    end
  end


  def self.roles
    %w(primary_developer supplemental_developer infrastructure_developer oncall_weekday_developer oncall_weekend_developer)
  end

  def self.default_start_date
    initial_date = generate_initial_date
    default_date = initial_date
    until default_date.wednesday? do
      default_date += 1
    end
    default_date
  end

private

  def self.generate_initial_date
    return Date.today if Week.count == 0
    latest_week = Week.order("start_date desc").limit(1)[0]
    latest_week.start_date + 7
  end

end
