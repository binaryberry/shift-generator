require "rails_helper"
require "spec_helper"

describe Scheduler do

  let!(:scheduler) { Scheduler.new(create(:week, start_date: Date.new(2015,11,27))) }
  let!(:week_4) { create(:week, start_date: Date.new(2015,11,20)) }
  let!(:week_3) { create(:week, start_date: Date.new(2015,11,13)) }
  let!(:week_2) { create(:week, start_date: Date.new(2015,11,06)) }
  let!(:week_1) { create(:week, start_date: Date.new(2015,10,31)) }

  before do
    @week_assignments = {}
    [week_1, week_2, week_3, week_4].each do |week|
      @week_assignments[week] = []
      %w{primary_dev supplemental_dev infrastructure_dev}.each do |role|
        @week_assignments[week] << create("#{role}_assignment", week: week)
      end
    end
  end

def assignment(week, role)
  @week_assignments[week].find{|assignment| assignment.role == "#{role}"}
end

	it "knows about the assignments of the previous week" do
    expect(scheduler.history).to match_array [assignment(week_4, "primary_dev"), assignment(week_4, "supplemental_dev"),assignment(week_4, "infrastructure_dev")]
	end

  it "knows about the assignments of the previous 2 weeks" do
    # binding.pry
    expect(scheduler.history(2)).to match_array [assignment(week_4, "primary_dev"), assignment(week_4, "supplemental_dev"),assignment(week_4, "infrastructure_dev"), assignment(week_3, "primary_dev"), assignment(week_3, "supplemental_dev"),assignment(week_3, "infrastructure_dev")]
  end

  it "knows the available people for each type of role" do
    create("primary_and_supplemental_dev")
    create("primary_dev")
    create("supplemental_dev")
    create("infrastructure_dev")
    aggregate_failures("available people") do
      expect(scheduler.people_available("primary_developer").count).to eq 2
      expect(scheduler.people_available("supplemental_developer").count).to eq 2
      expect(scheduler.people_available("infrastructure_developer").count).to eq 1
    end
  end

  it "can assign a random available person to an assignment" do
    available_dev = create(:primary_dev)
    new_assignment = scheduler.assign("primary_developer")
    expect(scheduler.week.assignments).to include(new_assignment)
    expect(new_assignment.person.roles).to include("primary_developer")
  end

  context "no_recent_assignment rule" do
    it "ensures there are 4 weeks between 2 shifts" do
      people_with_recent_shifts = [assignment(week_4, "primary_dev").person, assignment(week_3, "primary_dev").person, assignment(week_2, "primary_dev").person, assignment(week_1, "primary_dev").person]
      new_person = create(:primary_dev)
      list = people_with_recent_shifts.push(new_person)
      expect(scheduler.no_recent_assignment(list)).to eq [new_person]
    end
  end

  context "incompatible_shifts rule" do
    it "ensures people are not on 2nd line and on call in the same week" do

    end
  end
end

#PAUL: this seems to not work because my assignments are not attached to the scheduler, although they are attached to that week. pourquoi?
# def create_assignments
#   assignment_p4 = create(:primary_dev_assignment, week: week_4)
#   assignment_s4 = create(:supplemental_dev_assignment, week: week_4)
#   assignment_i4 = create(:infrastructure_dev_assignment, week: week_4)
#   assignment_p3 = create(:primary_dev_assignment, week: week_3)
#   assignment_s3 = create(:supplemental_dev_assignment, week: week_3)
#   assignment_i3 = create(:infrastructure_dev_assignment, week: week_3)
#   assignment_p2 = create(:primary_dev_assignment, week: week_2)
#   assignment_s2 = create(:supplemental_dev_assignment, week: week_2)
#   assignment_i2 = create(:infrastructure_dev_assignment, week: week_2)
#   assignment_p1 = create(:primary_dev_assignment, week: week_1)
#   assignment_s1 = create(:supplemental_dev_assignment, week: week_1)
#   assignment_i1 = create(:infrastructure_dev_assignment, week: week_1)
# end
