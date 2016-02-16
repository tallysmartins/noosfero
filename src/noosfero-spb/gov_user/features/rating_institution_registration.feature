Feature: Create institution on user report
  As a user
  I want to create a institution in use report of a software
  to add institution in report.

  Background:
    Given "GovUserPlugin" plugin is enabled
    And "SoftwareCommunitiesPlugin" plugin is enabled
    And "OrganizationRatings" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/environment_themes/set/noosfero-spb-theme
    And I go to /admin/plugins
    And I check "GovUserPlugin"
    And I check "SoftwareCommunitiesPlugin"
    And I check "Organization Ratings"
    And I press "Save changes"
    And the following softwares
      | name      | public_software | finality      |
      | Noosfero  | true            | some finality |

  @selenium
  Scenario: Test Additional JavaScript Fields
    Given I go to /profile/noosfero/plugin/organization_ratings/new_rating
    And I should not see "Number of Beneficiaries"
    And I should not see "Saved resources"
    And I should not see "Organization name or Enterprise name"
    When I click on anything with selector "comments-additional-information"
    Then I should see "Number of Beneficiaries"
    And I should see "Organization Name or Enterprise Name"
    And I should see "Saved Resources"

  @selenium
  Scenario: Show new institution fields when clicked in add new institution
    Given I go to /profile/noosfero/plugin/organization_ratings/new_rating
    And I sleep for 1 seconds
    And I click on anything with selector "comments-additional-information"
    And I fill in "input_institution" with "None institution"
    And I sleep for 2 seconds
    When I follow "Add"
    Then I should see "Public Institution"
    And I should see "Private Institution"
    And I should see "Corporate Name"
    And I should see "Name"
    And I should see "State"
    And I should see "City"
    And I should see "Country"
    And I should see "CNPJ"
    And I should see "Acronym"
    And I choose "Public Institution"
    And I should see "Governmental Sphere"
    And I should see "Governmental Power"
    And I should see "Juridical Nature"

  @selenium
  Scenario: Create new institution with name changed in the modal
    Given I go to /profile/noosfero/plugin/organization_ratings/new_rating
    And I sleep for 1 seconds
    And I click on anything with selector "comments-additional-information"
    And I fill in "input_institution" with "None institution"
    And I sleep for 2 seconds
    When I click on anything with selector "create_institution_link"
    And I fill in "community_name" with "Noosfero Institution"
    And I select "United States" from "Country"
    And I sleep for 2 seconds
    And I follow "Save"
    Then I should see "Noosfero Institution"

  @selenium
  Scenario: Check new institution name in the modal
    Given I go to /profile/noosfero/plugin/organization_ratings/new_rating
    And I sleep for 1 seconds
    And I click on anything with selector "comments-additional-information"
    And I fill in "input_institution" with "None institution"
    And I sleep for 2 seconds
    When I click on anything with selector "create_institution_link"
    Then I should see "None institution" in "Corporate Name" field
