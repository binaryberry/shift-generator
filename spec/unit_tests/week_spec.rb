require "rails_helper"

describe Week do

  it "cannot create a week without a start date" do
    expect{Week.create!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can save a week that starts on a Wednesday" do
    Week.create!(start_date: Date.new(2015,11,25))
    expect(Week.count).to eq 1
  end

  it "cannot save a week that starts on a Thursday" do
    expect{Week.create!(start_date: Date.new(2015,11,26))}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "two weeks cannot have the same start_date" do
    Week.create!(start_date: Date.new(2015,11,25))
    expect{Week.create!(start_date: Date.new(2015,11,25))}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can only have one assignment per role" do
    people = [create(:primary_developer), create(:primary_developer), create(:primary_developer)]
    role = Week.roles[0]
    week = Week.create!(start_date: Date.new(2015,11,25))
    scheduler = Scheduler.new(week)
    scheduler.assign(role)
    scheduler.assign(role)
    scheduler.assign(role)
    expect(week.assignments.all.count).to eq 1
  end

  context "when there are no other weeks in the database" do
    it "defaults the start date to next Wednesday" do
      Timecop.freeze(Time.local(2015, 11, 28))
      expect(Week.count).to eq 0
      expect(Week.default_start_date).to eq Date.new(2015,12,02)
    end
  end

  context "when some weeks exist in the database" do
    it "defaults the start date to the Wednesday following the latest week" do
      Timecop.freeze(Time.local(2015, 11, 21))
      expect(Week.count).to eq 0
      week = Week.create!(start_date: Date.new(2015,11,25))
      expect(Week.default_start_date).to eq Date.new(2015,12,02)
    end

  end

end
