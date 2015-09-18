Feature: Generate CSV from form

    Scenario: Homepage
      As a Delivery Manager,
        Given I am on the homepage,
        Then I see a form
        And a prompt to add a week

    Scenario:
        Given I am on the homepage,
        When I fill in the names of developers,
        Then I can download a csv file
