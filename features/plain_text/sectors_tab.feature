Feature: Sectors tab
  In order to know what projects belong to which sectors
  As a project manager
  I want a sectors page

  Scenario: home page
    Given I am on the home page
    And a sector exists with name: "Education"
    When I follow "Sectors"
    Then I should be on the sectors page
    And I should see "Education"
