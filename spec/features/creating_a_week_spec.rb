require 'rails_helper'

describe 'creating a week' do

  before do
    create(:primary_dev)
    create(:supplemental_dev)
    create(:infrastructure_dev)
    create(:oncall_weekday_dev)
    create(:oncall_weekend_dev)

  end

    it "creates a week with assignments when clicking on create week" do
      visit "/weeks"
      click_button "Create Week"
      within "table tbody tr td:nth-of-type(4)#assignment" do
        expect(page.text).to match(/\A\b.+\b\s\W\d+\W\z/) #developer names look like: Alan (1) due to Faker Gem and sequencing.
      end
    end

end
