require "rails_helper"
require "spec_helper"

describe Scheduler do

  let!(:scheduler) { Scheduler.new }
  let(:week_5) { create(:week, start_date: Date.new(2015,11,27)) }
  let(:week_4) { create(:week, start_date: Date.new(2015,11,20)) }
  let(:week_3) { create(:week, start_date: Date.new(2015,11,13)) }
  let(:week_2) { create(:week, start_date: Date.new(2015,11,06)) }
  let(:week_1) { create(:week, start_date: Date.new(2015,10,31)) }
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
      expect(scheduler.history(week_5)).to match_array [assignment_p4, assignment_s4, assignment_i4]
  	end

    it "knows about the assignments of the previous 2 weeks" do
      expect(scheduler.history(week_5, 2)).to match_array [assignment_p4, assignment_s4, assignment_i4, assignment_p3, assignment_s3, assignment_i3]
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
