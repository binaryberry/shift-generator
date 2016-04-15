require "rails_helper"

describe Person do

  let!(:infrastructure_developer) { create(:infrastructure_developer) }
  let!(:primary_and_supplemental_dev) { create(:primary_and_supplemental_dev) }
  let!(:supplemental_developer) { create(:supplemental_developer) }

  it "allows to see the list of available developers for each role" do
    expect(Person.with_role("supplemental_developer")).to contain_exactly(primary_and_supplemental_dev, supplemental_developer)
  end

  it "prevents duplicates" do
    Person.create(name: infrastructure_developer.name, roles: ['infrastructuredev'])
    expect(Person.where(name: infrastructure_developer.name).count).to eq 1
  end

  it "can be both primary and supplemental dev" do
    expect(Person.find_by(name: primary_and_supplemental_dev.name)).to have_attributes(roles: ['primary_developer', 'supplemental_developer'])
  end

  it "can't be primary and infrastructure dev" do
    expect{Person.create!(roles: ['primary_developer', 'infrastructure_developer'])}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "can't be supplemental and infrastructure dev" do
    expect{Person.create!(roles: ['primary_developer', 'infrastructure_developer'])}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is active when created" do
    person = Person.create(name: "Charles Darwin", roles: ["primary_developer"])
    expect(person).to be_active
  end

end
