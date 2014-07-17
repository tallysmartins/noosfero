Feature: Institution Field
  As a user
  I want to sign up resgistring my institution
  So others users can use it

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And I go to /account/logout

  @selenium
  Scenario: Show new institution field when another institution is selected
    Given I go to /account/signup
    When I select "Other" from "Institution"
    And I should see "New Institution"
    And I fill in "institution_name" with "Test Institution"
    And I fill in "profile_data_name" with " "
    Then I should see "Test Institution" within "#user_institution_id"
