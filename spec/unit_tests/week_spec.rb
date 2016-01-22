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
    role = Week.roles[0]
    week = Week.create!(start_date: Date.new(2015,11,25))
    scheduler = Scheduler.new(week)
    scheduler.assign(role)
    scheduler.assign(role)
    scheduler.assign(role)
    expect(week.assignments.all.count).to eq 1
  end

end
