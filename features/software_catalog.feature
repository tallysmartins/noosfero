Feature: Search software
  As a user
  I want to be able to search catalogued software
  So that I find a software that fit my needs
  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
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
      | name           | public_software | categories        |
      | Software One   | true            | Health            |
      | Software Two   | true            | Health, Education |
      | Software Three | false           | Education         |


  Scenario: Show all "public_software" softwares when open search page
    Given I go to /search/software_infos
    Then I should see "Software One"
    Then I should see "Software Two"

  Scenario: Show all "public_software" softwares when search software
    Given I go to /search/software_infos
    And I fill in "search-input" with "Software"
    Then I should see "Software One"
    Then I should see "Software Two"

  Scenario: Show software "One" when searching for "Software One"
    Given I go to /search/software_infos
    And I fill in "search-input" with "Software One"
    And I press "Filter"
    Then I should see "Software One"
    Then I should not see "Software Two"

  Scenario: Show software ordered by name when "Name A-Z" is selected
    Given I go to /search/software_infos
    And I select "Name A-Z" from "sort"
    And I press "Filter"
    Then I should see "Software One" before "Software Two"

  Scenario: Show software in reverse order by name when "Name Z-A" is selected
    Given I go to /search/software_infos
    And I select "Name Z-A" from "sort"
    And I press "Filter"
    Then I should see "Software Two" before "Software One"

  Scenario: Show softwares with selected category in filter
    Given I go to /search/software_infos
    And I follow "Education"
    Then I should see "Software Two"
    And I should not see "Software One"


  @selenium
  Scenario: Show only "Software Two" when searching for "Education" category
    Given I go to /search/software_infos
    And I click on anything with selector "#filter-option-catalog-software"
    And I check "Education"
    Then I should see "Software Two"
    And I should not see "Software One"

  @selenium
  Scenario: Show both Software "One" and "Two" when searching for "Health" category
    Given I go to /search/software_infos
    And I click on anything with selector "#filter-option-catalog-software"
    And I check "Health"
    Then I should see "Software One"
    And I should see "Software Two"

  @selenium
  Scenario: Show not "public_software" when "Include in results" is checked
    Given I go to /search/software_infos
    And I click on anything with selector "#filter-option-catalog-software"
    And I check "include_non_public"
    Then I should see "Software One"
    And I should see "Software Two"
    And I should see "Software Three"
