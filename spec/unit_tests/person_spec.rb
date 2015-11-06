require "rails_helper"

describe Person do

  it "allows to see the list of available developers for each role" do
    bob = Person.create(name: "bob", roles: ['infrastructuredev'])
    alex = Person.create(name: "Alex", roles: ['primarydev', 'supplementaldev'])
    daz = Person.create(name: "Daz", roles: ['supplementaldev'])
    expect(Person.with_role("supplementaldev").all).to eq([alex, daz])
  end

  it "prevents duplicates" do
    bob = Person.create(name: "bob", roles: ['infrastructuredev'])
    second_bob = Person.create(name: "bob", roles: ['infrastructuredev'])
    expect(second_bob).to be_invalid
  end
end
