class Person < ActiveRecord::Base
	has_many :assignments, dependent: :destroy
	has_many :weeks, through: :assignments, dependent: :destroy
  validates_each :roles, presence: true do |record, attr, value|
    has_incompatibility = value.include?("primary_developer") || value.include?("supplemental_developer")
    record.errors.add(attr, "Infrastructure Developers can't also be Primary or Supplemental") if value.include?("infrastructure_developer") && has_incompatibility
  end
  validate :allowed_role
	validates :name, presence: true, length: { minimum: 2 }, uniqueness: true

  scope :with_role, ->(role) { where("roles @> ?", "{#{role}}") }

  def allowed_role
    if roles.present? && Week::roles.include?(roles)
      errors.add(:allowed_role, "value disallowed")
    end
  end

  def recent_assignment(week)
    assignments = self.assignments
    recent_in_days = 28
    range = Range.new(week.start_date - recent_in_days, week.start_date)
    assignments.any? {|assignment| range.cover?(assignment.week.start_date) }
  end

  def self.teams
    ["Core Formats", "Custom", "Finding Things", "Performance Platform", "Publishing Platform", "Infrastructure", "Other"]
  end

end
