require "rails_helper"
require "spec_helper"

describe Scheduler do

  let!(:scheduler) { Scheduler.new(create(:week, start_date: Date.new(2015,11,27))) }
  let!(:week_4) { create(:week, start_date: Date.new(2015,11,20)) }
  let!(:week_3) { create(:week, start_date: Date.new(2015,11,13)) }
  let!(:week_2) { create(:week, start_date: Date.new(2015,11,06)) }
  let!(:week_1) { create(:week, start_date: Date.new(2015,10,31)) }
  let!(:assignment_p4) { create(:primary_dev_assignment, week: week_4)}
  let!(:assignment_s4) { create(:supplemental_dev_assignment, week: week_4)}
  let!(:assignment_i4) { create(:infrastructure_dev_assignment, week: week_4)}
  let!(:assignment_p3) { create(:primary_dev_assignment, week: week_3)}
  let!(:assignment_s3) { create(:supplemental_dev_assignment, week: week_3)}
  let!(:assignment_i3) { create(:infrastructure_dev_assignment, week: week_3)}
  let!(:assignment_p2) { create(:primary_dev_assignment, week: week_2)}
  let!(:assignment_s2) { create(:supplemental_dev_assignment, week: week_2)}
  let!(:assignment_i2) { create(:infrastructure_dev_assignment, week: week_2)}
  let!(:assignment_p1) { create(:primary_dev_assignment, week: week_1)}
  let!(:assignment_s1) { create(:supplemental_dev_assignment, week: week_1)}
  let!(:assignment_i1) { create(:infrastructure_dev_assignment, week: week_1)}

	it "knows about the assignments of the previous week" do
    expect(scheduler.history).to match_array [assignment_p4, assignment_s4, assignment_i4]
	end

  it "knows about the assignments of the previous 2 weeks" do
    expect(scheduler.history(2)).to match_array [assignment_p4, assignment_s4, assignment_i4, assignment_p3, assignment_s3, assignment_i3]
  end

  it "knows the available people for each type of role" do
    create(:primary_and_supplemental_dev)
    aggregate_failures("available people") do
      expect(scheduler.people_available?("primary_developer").count).to eq 5
      expect(scheduler.people_available?("supplemental_developer").count).to eq 5
      expect(scheduler.people_available?("infrastructure_developer").count).to eq 4
    end
  end
end
