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
    updated_list = no_recent_assignment(list)
    different_teams(updated_list)
  end

  def assign(role)
    available_person = people_available(role).sample
    return unless available_person

    assignment = Assignment.find_or_initialize_by(week: self.week, role: role)
    assignment.person = available_person
    assignment.save!
  end

  def no_recent_assignment(list)
    list.reject{|person| person.recent_assignment(@week)}
  end

  def different_teams(list)
    mapping = {}
    list.each do |person|
      mapping[person.team] = person
    end
    mapping.values
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
