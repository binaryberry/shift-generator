class Person < ActiveRecord::Base
  after_create :default_values
  has_many :assignments, dependent: :destroy
  has_many :weeks, through: :assignments, dependent: :destroy
  validates_each :roles, presence: true
  validates :name, presence: true, length: { minimum: 2 }, uniqueness: true
  scope :with_role, ->(role) { where("roles @> ?", "{#{role}}") }

  def recent_assignment(week)
    assignments = self.assignments
    recent_in_days = 28
    range = Range.new(week.start_date - recent_in_days, week.start_date)
    assignments.any? {|assignment| range.cover?(assignment.week.start_date) unless assignment.week.nil? }
  end

  def self.teams
    ["Core Formats", "Custom", "Finding Things", "Infrastructure", "Performance Platform", "Publishing Platform", "Other"]
  end

  def remove_future_assignments
    assignments = self.assignments
    assignments.each do |assignment|
      if assignment.week.start_date > Date.today
        assignment.person=nil
        assignment.save!
      end
    end
  end

private

  def default_values
    self.active ||= true
  end

end
