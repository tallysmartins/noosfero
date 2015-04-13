Feature: Institution Field
  As a user
  I want to sign up resgistring my institution
  So others users can use it

  Background:
    Given "GovUserPlugin" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "GovUserPlugin"
    And I press "Save changes"
    And Institutions has initial default values on database
    And I am logged in as mpog_admin

  @selenium
  Scenario: Show new institution fields when clicked in create new institution
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I should see "New Institution"
    And I should see "Public Institution"
    And I should see "Private Institution"
    And I should see "Corporate Name"
    And I should see "Name"
    And I should see "State"
    And I should see "City"
    And I should see "Country"
    And I should see "CNPJ"
    And I should see "Acronym"
    And I choose "Public Institution"
    Then I should see "Governmental Sphere:"
    And I should see "Governmental Power:"
    And I should see "Juridical Nature:"
