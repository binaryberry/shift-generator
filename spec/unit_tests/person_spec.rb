require "rails_helper"

describe Person do

  let!(:bob) { Person.create!(name: "bob", roles: ['infrastructure_developer']) }
  let!(:alex) { Person.create!(name: "Alex", roles: ['primary_developer', 'supplemental_developer']) }

  it "allows to see the list of available developers for each role" do
    daz = Person.create!(name: "Daz Ahern", roles: ['supplemental_developer'])
    expect(Person.with_role("supplemental_developer")).to contain_exactly(daz, alex)
  end

  it "prevents duplicates" do
    second_bob = Person.create(name: "bob", roles: ['infrastructuredev'])
    expect(Person.where(name: "bob").count).to eq 1
  end

  it "can be both primary and supplemental dev" do
    expect(Person.find_by(name: "Alex")).to have_attributes(roles: ['primary_developer', 'supplemental_developer'])
  end

  it "can't be primary and infrastructure dev" do
    expect{Person.create!(name: "John", roles: ['primary_developer', 'infrastructure_developer'])}.to raise_error
  end

  it "can't be supplemental and infrastructure dev" do
    expect{Person.create!(name: "John", roles: ['primary_developer', 'infrastructure_developer'])}.to raise_error
  end

end
