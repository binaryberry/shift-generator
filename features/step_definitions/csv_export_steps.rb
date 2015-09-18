Given(/^I am on the homepage,$/) do
  visit '/'
end

Then(/^I see a form$/) do
  expect(page).to have_css("form")
end

Then(/^a prompt to add a week$/) do
  expect(page).to have_link("Add a week")
end

Given(/^I fill in the names of developers,$/) do
	fill_in "names", :with => "Tatiana"
end

Then(/^I can download a csv file$/) do
  find_button('Download csv').click
  expect(page).to have_content("Download complete")
end

