#Comment on line 1
#Comment on line 2
@tag1 @tag2
Feature: Feature Text
  In order to test multiline forms
  As a ragel writer
  I need to check for complex combinations

  #Comment on line 9
  #Comment on line 11
  Background: 
    Given this is a background step
    And this is another one

  @tag3 @tag4
  Scenario: Reading a Scenario
    Given there is a step
    But not another step

  @tag3
  Scenario: Reading a second scenario
    With two lines of text

    #Comment on line 24
    Given a third step with a table
      | a | b |
      | c | d |
      | e | f |
    And I am still testing things
    And I am done testing these tables
    #Comment on line 29
    Then I am happy
      | g | h |
      | e | r |
      | k | i |
      | n |   |

  Scenario: Hammerzeit XX
    Given All work and no play
    Then crazy
      """
      Makes Homer something something
      And something else
      """

  @more
  Scenario Outline: More
    Given Some <whaaa>

    @neat
    Examples: Neato XX
      | whaa |
      | neat |
      | beat |

    @hamster
    Examples: Rodents
      | whaa  |
      | hammy |
      | mousy |