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

    it "allows to edit a week's date and assignments when clicking on edit a week" do
      visit "/weeks"
      click_button "Create Week"
      within "table tbody tr td:nth-of-type(7) div#edit-week a" do
        click_button "Edit"
      end
      fill_in "start_date", with: "25/11/2015"
      click_button "Update Week"

      expect(page.text).to have_content("Week updated")
      expect(page.text).to have_content("25/11/2015")
    end

end
