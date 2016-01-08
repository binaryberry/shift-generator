require "rails_helper"

describe Week do

  let!(:week) { Week.new(start_date: Date.new(2015,11,25)) }

  it "cannot create a week without a start date" do
    expect{Week.create}.to raise_error(NoMethodError)
  end

  it "can save a week that starts on a Wednesday" do
    week.save
    expect(Week.count).to eq 1
  end

  it "cannot save a week that starts on a Thursday" do
    expect{Week.create!(start_date: Date.new(2015,11,26))}.to raise_error(ActiveRecord::RecordInvalid)
  end

end
