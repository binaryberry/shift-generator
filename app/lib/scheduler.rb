class Scheduler

  attr_reader :assignments

    def history(week, weeks_ago=1)
      @assignments_list = []

    if weeks_ago == 1
      old_week = Week.find_by(start_date: find_start_date(week, weeks_ago))
      old_week.assignments.each do |assignment|
        @assignments_list << assignment
      end
    else
      # binding.pry
      weeks = {}
      while weeks_ago > 0
        weeks["#{weeks_ago}_weeks_ago"] = Week.find_by(start_date: find_start_date(week, weeks_ago))
        weeks_ago -= 1
      end

      weeks.each do |week_name, week_object|
        week_object.assignments.each {|assignment| @assignments_list << assignment}
      end

    end
    @assignments_list
  end

private
  def find_start_date(week, weeks_ago)
    week.start_date - (weeks_ago * 7)
  end

end
