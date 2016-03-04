Feature: go to software search when click on category
  As a user
  I want to select a category
  to see the softwares with the same category

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

  Scenario: Search softwares by education category
    Given I go to software-three's control panel
    And I follow "Edit sideboxes"
    And I follow "Add a block"
    And I choose "Categories and Tags"
    And I press "Add"
    And I go to /software-three
    When I follow "Education"
    Then I should see "Software Two"
    And I should see "Software Three"