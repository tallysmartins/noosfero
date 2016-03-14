Feature: go to software search when click on category
  As a user
  I want to select a category
  to see the softwares with the selected category

  Background:
    Given "SoftwareCommunitiesPlugin" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "SoftwareCommunitiesPlugin"
    And I press "Save changes"
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
    And the following blocks
      | owner       | type                                               |
      | environment | SoftwareCommunitiesPlugin::CategoriesSoftwareBlock |

  Scenario: Search softwares by education category
    Given I go to /
    When I follow "Education"
    Then I should see "Software Two"
    And I should see "Software Three"
    And I should not see "Software One"

