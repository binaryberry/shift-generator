require "rails_helper"

describe Week do
	context "when creating a new week" do
		it "creates a new assignment for each role" do
			week = Week.create
			expect(week.assignments.count).to eq 5
		end
	end
end
