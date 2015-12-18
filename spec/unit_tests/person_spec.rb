require "rails_helper"

describe Person do

  let!(:infrastructure_dev) { create(:infrastructure_dev) }
  let!(:primary_and_supplemental_dev) { create(:primary_and_supplemental_dev) }
  let!(:supplemental_dev) { create(:supplemental_dev) }

  it "allows to see the list of available developers for each role" do
    expect(Person.with_role("supplemental_developer")).to contain_exactly(primary_and_supplemental_dev, supplemental_dev)
  end

  it "prevents duplicates" do
    Person.create(name: infrastructure_dev.name, roles: ['infrastructuredev'])
    expect(Person.where(name: infrastructure_dev.name).count).to eq 1
  end

  it "can be both primary and supplemental dev" do
    expect(Person.find_by(name: primary_and_supplemental_dev.name)).to have_attributes(roles: ['primary_developer', 'supplemental_developer'])
  end

  it "can't be primary and infrastructure dev" do
    expect{Person.create!(roles: ['primary_developer', 'infrastructure_developer'])}.to raise_error
  end

  it "can't be supplemental and infrastructure dev" do
    expect{Person.create!(roles: ['primary_developer', 'infrastructure_developer'])}.to raise_error
  end

end
