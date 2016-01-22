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
    %w(primary_developer supplemental_developer infrastructure_developer oncall_weekday oncall_weekend)
  end

end
