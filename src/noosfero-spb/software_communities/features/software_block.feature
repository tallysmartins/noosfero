Feature: edit adherent fields
  As a user
  I want to edit adherent fields
  to mantain my public software up to date.

  Background:
    Given "SoftwareCommunitiesPlugin" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "SoftwareCommunitiesPlugin"
    And I press "Save changes"
    And the following softwares
    | name             | public_software | finality      |
    | Public Software  | true            | some finality |
    | Generic Software | false           | some finality |

  Scenario: Add software block
    Given I am logged in as mpog_admin
    And I follow "Control panel"
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    And I choose "Softwares"
    And I press "Add"
    Then I should see "softwares"

  Scenario: Change software block to generic software block
    Given I am logged in as mpog_admin
    And I go to /myprofile/mpog_admin
    And I follow "Control panel"
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    And I choose "Softwares"
    And I press "Add"
    And I follow "Edit" within ".softwares-block"
    And I select "Generic" from "block_software_type"
    And I press "Save"
    Then I should see "generic software"

  Scenario: Change software block to generic software block
    Given I am logged in as mpog_admin
    And I follow "Control panel"
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    And I choose "Softwares"
    And I press "Add"
    And I follow "Edit" within ".softwares-block"
    And I select "Public" from "block_software_type"
    And I press "Save"
    Then I should see "public software"
