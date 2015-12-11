require "rails_helper"
require "spec_helper"

describe Scheduler do

  let!(:scheduler) { Scheduler.new }
  let(:new_week) { create(:week, start_date: Date.new(2015,11,27)) }
  let(:previous_week) { create(:week, start_date: Date.new(2015,11,20)) }
  let(:bob) { create(:person, name: "bob", roles: ["primary_dev"]) }
  let(:alex) { create(:person, name: "alex", roles: ["supplemental_dev"]) }
  let!(:assignment_one) { create(:primary_dev_assignment, week: previous_week, person: bob) }
  let!(:assignment_two) { create(:supplemental_dev_assignment, week: previous_week, person: alex) }

  context "when creating a new week" do
  	it "knows about the assignments of the previous week" do
      expect(scheduler.history(new_week)).to match_array [assignment_one, assignment_two]
  	end

    it "knows about the assignments of the previous 2 weeks" do
      pre_previous_week = Week.create!(start_date: Date.new(2015,11,13))
      assignment_three = Assignment.create(week: pre_previous_week, person: bob, role: "primary_dev")
      assignment_four = Assignment.create(week: pre_previous_week, person: alex, role: "supplemental_dev")

      expect(scheduler.history(new_week, 2)).to match_array [assignment_one, assignment_two, assignment_three, assignment_four]
    end
  end
end
