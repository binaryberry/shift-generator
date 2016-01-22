class Scheduler

  attr_reader :assignments, :week

  def initialize(week)
    @week = week
  end

  def history(weeks_ago=1)
    find_list_of_weeks(weeks_ago)
    assignments_list = []
    @weeks.each{|w| assignments_list << w.assignments}
    assignments_list.flatten
  end

  def people_available(role)
    list = Person.with_role(role).to_a
    no_recent_assignment(list)
  end

  def assign(role)
    person = people_available(role).sample
    old_assignment ||= Assignment.find_by(week: self.week)
    ActiveRecord::Base.transaction do
      old_assignment.destroy if old_assignment
      assignment = Assignment.new(week: self.week, person: person, role: role)
      assignment.save!
    end
  end

  def no_recent_assignment(list)
    list.reject{|person| person.recent_assignment(@week)}
  end

  def assignments
    @week.assignments
  end

private
  def find_start_date(weeks_ago)
    @week.start_date - (weeks_ago * 7)
  end

  def find_list_of_weeks(weeks_ago)
    @weeks = []
    while weeks_ago > 0
      @weeks << Week.find_by(start_date: find_start_date(weeks_ago))
      weeks_ago -= 1
    end
  end
end
