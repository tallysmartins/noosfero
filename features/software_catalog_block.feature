Feature:Search catalogued software
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
    And the following blocks
      | owner       | type               |
      | environment | SearchCatalogBlock |
    And the following softwares
    | name             | public_software |
    | Public Software  | true            |
    | Generic Software | false           |
    And the following users
      | login      | name        | email                  |
      | joaosilva  | Joao Silva  | joaosilva@example.com  |
    And I am logged in as "joaosilva"

  Scenario: successfull search
    Given I go to /search/software_infos
    And I should see "Public Software"
    And I should see "Generic Software"
    And I fill in "search-input" with "Generic"
    And I press "Search"
    And I should see "Generic Software"
    Then I should not see "Public Software"
