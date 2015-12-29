class Assignment < ActiveRecord::Base
  belongs_to :week
  belongs_to :person

  def attribute(role)
    role = params(role)
  end

  # def self.recent_assignment(week, person)
  #   recent_in_days = 28
  #   range = Range.new(week.start_date - recent_in_days, week.start_date)
  #
  #   Assignment.where(person: person)
  #
  #   #   true if assignment && range.cover?(Week.start_date)
  #
  # end
end
