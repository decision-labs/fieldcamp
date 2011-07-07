Feature: Event images upload
  In order to make the event information more useful
  As a publisher from field
  I want to be able to upload images

  # TODO: add test: 
  # http://cassiomarques.wordpress.com/2009/01/23/how-to-test-file-uploads-with-cucumber/
  # http://stackoverflow.com/questions/4812606/how-do-i-find-an-image-on-a-page-with-cucumber-capybara-in-rails-3
  Scenario: Upload new image
    Given I am on edit event page
    When I upload an image with valid data
    Then I should be on the event's project
    And I shhould see a new image

  Scenario: Delete image
    Given I am on edit event page
    When I delete an old image
    Then I should be on the edit event page
    And I should see image was deleted
