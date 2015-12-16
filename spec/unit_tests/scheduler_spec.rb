require "rails_helper"
require "spec_helper"

describe Scheduler do

  let!(:scheduler) { Scheduler.new }
  let(:new_week) { create(:week, start_date: Date.new(2015,11,27)) }
  let(:previous_week) { create(:week, start_date: Date.new(2015,11,20)) }
  let(:bob) { create(:person, roles: ["primary_dev"]) }
  let(:alex) { create(:person, roles: ["supplemental_dev"]) }
  let!(:assignment_one) { create(:primary_dev_assignment, week: previous_week, person: bob) }
  let!(:assignment_two) { create(:supplemental_dev_assignment, week: previous_week, person: alex) }

  	it "knows about the assignments of the previous week" do
      expect(scheduler.history(new_week)).to match_array [assignment_one, assignment_two]
  	end

    it "knows about the assignments of the previous 3 weeks" do
      pre_previous_week = create(:week, start_date: Date.new(2015,11,13))
      assignment_three = create(:primary_dev_assignment, week: pre_previous_week, person: bob)
      assignment_four = create(:supplemental_dev_assignment, week: pre_previous_week, person: alex)

      expect(scheduler.history(new_week, 2)).to match_array [assignment_one, assignment_two, assignment_three, assignment_four]
    end

#use shuffle to randomise things. Stub it to remove randomness. One method per rule, each returns a list of valid devs. note to self: could be a good indicator of too many rules and not enough devs. 
    context "when creating a new week with valid assignments" do
      it "ensures there are 4 weeks between 2 shifts" do
        a_week_1 = scheduler.produce_assignments(new_week)
        expect(a_week.rule_1).to match_array()
      end
    end
  end
end
