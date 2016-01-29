require "rails_helper"
require "spec_helper"

describe Scheduler do

  let!(:scheduler) { Scheduler.new(create(:week, start_date: Date.new(2015,11,25))) }
  let!(:week_4) { create(:week, start_date: Date.new(2015,11,18)) }
  let!(:week_3) { create(:week, start_date: Date.new(2015,11,11)) }
  let!(:week_2) { create(:week, start_date: Date.new(2015,11,04)) }
  let!(:week_1) { create(:week, start_date: Date.new(2015,10,28)) }

  before do
    week_0 = scheduler.week
    @week_assignments = {}
    [week_0, week_1, week_2, week_3, week_4].each do |week|
      @week_assignments[week] = []
      Week.roles.each do |role|
        @week_assignments[week] << create("#{role}_assignment", week: week)
      end
    end
  end

def assignment(week, role)
  @week_assignments[week].find{|assignment| assignment.role == "#{role}"}
end

	it "knows about the assignments of the previous week" do
    previous_week_assignments = []
    Week.roles.each do |role|
      previous_week_assignments << assignment(week_4, role)
    end
    expect(scheduler.history).to match_array previous_week_assignments
	end

  it "knows about the assignments of the previous 2 weeks" do
    previous_weeks_assignments = []
    Week.roles.each do |role|
      previous_weeks_assignments << assignment(week_4, role)
      previous_weeks_assignments << assignment(week_3, role)
    end
    expect(scheduler.history(2)).to match_array previous_weeks_assignments
  end

  it "knows the available people for each type of role" do
    create("primary_and_supplemental_dev")
    create("primary_developer")
    create("supplemental_developer")
    create("infrastructure_developer")
    aggregate_failures("available people") do
      expect(scheduler.people_available("primary_developer").count).to eq 2
      expect(scheduler.people_available("supplemental_developer").count).to eq 2
      expect(scheduler.people_available("infrastructure_developer").count).to eq 1
    end
  end

  it "can assign a random available person to an assignment" do
    available_dev = create(:primary_dev)
    scheduler.assign("primary_developer")
    expect(scheduler.assignments.all.select {|a| a.role == "primary_developer"}.count).to eq 1
  end

  context "no_recent_assignment rule" do
    it "ensures there are 4 weeks between 2 shifts" do
      people_with_recent_shifts = [assignment(week_4, "primary_developer").person, assignment(week_3, "primary_developer").person, assignment(week_2, "primary_developer").person, assignment(week_1, "primary_developer").person]
      new_person = create(:primary_developer)
      list = people_with_recent_shifts.push(new_person)
      expect(scheduler.no_recent_assignment(list)).to eq [new_person]
    end
  end

  context "incompatible_shifts rule" do
    it "ensures people are not on 2nd line and on call in the same week" do

    end
  end
end
