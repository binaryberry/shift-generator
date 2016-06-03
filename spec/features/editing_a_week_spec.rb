require 'rails_helper'

describe 'editing a week' do

  before do
    create(:primary_developer)
    create(:supplemental_developer)
    create(:infrastructure_developer)
    create(:oncall_weekday_developer)
    create(:oncall_weekend_developer)
    visit "/weeks"
    click_button "Create Week"
  end

    it "creates a week with assignments when clicking on create week" do
      within ".edit-table" do
        click_link "Edit"
      end

      create(:primary_developer, name: "Tony Stark")
      visit current_path
      select('Tony Stark', from: 'week[assignment][0][person_id]')

      within ".submit-button" do
        click_button "Update Week"
      end

      within "tr:nth-child(1) > td:nth-child(2)" do
        expect(page.text).to eq "Tony Stark"
      end
    end

end
