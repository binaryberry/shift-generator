require 'rails_helper'

describe 'viewing weeks' do

  before do
    create_developer_set
    create_developer_set
    create_developer_set
    visit "/weeks"
    Timecop.freeze(Time.local(2015, 11, 18))
    click_button "Create Week"
    click_button "Create Week"
    click_button "Create Week"
    Timecop.freeze(Time.local(2015, 11, 26))
  end

  context "when on the homepage" do
    it "shows current weeks, not previous weeks" do
      visit current_path
      within 'table > tbody' do
        expect(page).to have_xpath(".//tr", :count => 3)
      end
      within "tr:nth-child(2) > td:nth-child(1)" do
        expect(page).to have_content("2 Dec 2015")
      end
    end

  end

  context "when looking at the history" do

  end

    def create_developer_set
      create(:primary_developer)
      create(:supplemental_developer)
      create(:infrastructure_developer)
      create(:oncall_weekday_developer)
      create(:oncall_weekend_developer)
    end

end
