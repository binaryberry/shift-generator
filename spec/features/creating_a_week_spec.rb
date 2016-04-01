require 'rails_helper'

describe 'creating a week' do

  before do
    create(:primary_developer)
    create(:supplemental_developer)
    create(:infrastructure_developer)
    create(:oncall_weekday_developer)
    create(:oncall_weekend_developer)
  end

    it "creates a week with assignments when clicking on create week" do
      visit "/weeks"
      click_button "Create Week"
      within "table tbody tr:nth-of-type(2) td:nth-of-type(2)" do
        expect(page.text).to match(/\A\b.+\b\s\W\d+\W\z/) #developer names look like: Alan (1) due to Faker Gem and sequencing.
      end
      within "table tbody tr:nth-of-type(2) td:nth-of-type(3)" do
        expect(page.text).to match(/\A\b.+\b\s\W\d+\W\z/)
      end
      within "table tbody tr:nth-of-type(2) td:nth-of-type(4)" do
        expect(page.text).to match(/\A\b.+\b\s\W\d+\W\z/)
      end
      within "table tbody tr:nth-of-type(2) td:nth-of-type(5)" do
        expect(page.text).to match(/\A\b.+\b\s\W\d+\W\z/)
      end
      within "table tbody tr:nth-of-type(2) td:nth-of-type(6)" do
        expect(page.text).to match(/\A\b.+\b\s\W\d+\W\z/)
      end
    end

end
