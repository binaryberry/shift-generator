class Week < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  accepts_nested_attributes_for :assignments, allow_destroy: true
  validates :start_date, presence: true


  def self.roles
    %w(primary_developer supplemental_developer infrastructure_developer oncall_weekday oncall_weekend )
  end

  def get_assignments
    assignments = []
    self.assignments.each {|assignment| assignments << assignment}
  end

end
