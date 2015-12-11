class Scheduler

  attr_reader :assignments

  def history(week, weeks_ago=1)
    find_list_of_weeks(week, weeks_ago)
    @assignments = @weeks.map(&:get_assignments).flatten
    @assignments
  end

private
  def find_start_date(week, weeks_ago)
    week.start_date - (weeks_ago * 7)
  end

  def find_list_of_weeks(week, weeks_ago)
    @weeks = []
    while weeks_ago > 0
      @weeks << Week.find_by(start_date: find_start_date(week, weeks_ago))
      weeks_ago -= 1
    end
  end
end
