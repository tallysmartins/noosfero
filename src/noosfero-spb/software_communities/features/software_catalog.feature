Feature: Search software
  As a user
  I want to be able to search catalogued software
  So that I find a software that fit my needs
  Background:
    Given "SoftwareCommunitiesPlugin" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "SoftwareCommunitiesPlugin"
    And I press "Save changes"
    And I go to /account/logout
    And the following categories
      | name     | display_in_menu |
      | Software | true            |
    And the following categories
      | parent   | name        | display_in_menu |
      | Software | Health      | true            |
      | Software | Education   | true            |
    And the following softwares
      | name           | public_software | categories        | finality      |
      | Software One   | true            | Health            | some finality |
      | Software Two   | true            | Health, Education | some finality |
      | Software Three | false           | Education         | some finality |


  Scenario: Show all "public_software" softwares when open search page
    Given I go to /search/software_infos
    Then I should see "Software One"
    Then I should see "Software Two"

  Scenario: Show all "public_software" softwares when search software
    Given I go to /search/software_infos
    And I fill in "search-input" with "Software"
    Then I should see "Software One"
    Then I should see "Software Two"

  @selenium
  Scenario: Show software "One" when searching for "Software One"
    Given I go to /search/software_infos
    And I fill in "search-input" with "One"
    And I keyup on selector "#search-input"
    Then I should see "Software One"
    Then I should not see "Software Two"

  @selenium
  Scenario: Show software ordered by name when "Name A-Z" is selected
    Given I go to /search/software_infos
    And I select "Name A-Z" from "sort"
    And I sleep for 3 seconds
    Then I should see "Software One" before "Software Two"

  @selenium
  Scenario: Show software in reverse order by name when "Name Z-A" is selected
    Given I go to /search/software_infos
    And I select "Name Z-A" from "sort"
    And I sleep for 3 seconds
    Then I should see "Software Two" before "Software One"

  @selenium
  Scenario: Show only "Software Two" when searching for "Education" category
    Given I go to /search/software_infos
    And I click on anything with selector "filter-option-catalog-software"
    And I check "Education"
    Then I should see "Software Two"
    And I should not see "Software One"

  @selenium
  Scenario: Show both Software "One" and "Two" when searching for "Health" category
    Given I go to /search/software_infos
    And I click on anything with selector "filter-option-catalog-software"
    And I check "Health"
    Then I should see "Software One"
    And I should see "Software Two"

  @selenium
  Scenario: Show not "public_software" when "Include in results" is checked
    Given I go to /search/software_infos
    And I choose "all_radio_button"
    Then I should see "Software One"
    And I should see "Software Two"
    And I should see "Software Three"

  @selenium
  Scenario: See software rating on catalog
    Given plugin "OrganizationRatings" is enabled on environment
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "Organization Ratings"
    And I press "Save changes"
    And I go to /admin/admin_panel/site_info
    And I select "Software Público" from "environment_theme"
    And I press "Save"
    And I go to /account/logout
    Given the following user
      | login     | name       |
      | joaosilva | Joao Silva |
    And the following blocks
      | owner         | type                      |
      | software-two  | AverageRatingBlock        |
      | software-two  | OrganizationRatingsBlock  |
    And the environment domain is "localhost"
    And I am logged in as "joaosilva"
    And I go to /profile/software-two/plugin/organization_ratings/new_rating
    And I press "Enviar"
    And I go to /search/software_infos
    When I select "Favorites" from "sort"
    And I sleep for 3 seconds
    Then I should see "Software Two" before "Software One"
    And I should see "1" of this selector "div.medium-star-positive"
    And I should see "4" of this selector "div.medium-star-negative"
