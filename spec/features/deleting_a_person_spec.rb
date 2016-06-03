require 'rails_helper'

describe 'deleting a person' do

  before do
    @person = create(:primary_developer, name: "Neil deGrasse Tyson", active: true)
  end

    it "updates the shifts of deleted people" do
      visit "/"
      click_button("Create Week")
      visit "/people"
      within "td.delete" do
        click_link("Delete")
      end
      visit "/people"
      expect(page).not_to have_content("Neil deGrasse Tyson")
      visit "/"
      screenshot_and_save_page
      expect(page).to have_css(".assignment-missing")
    end

end
