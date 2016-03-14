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
    And the following blocks
      | owner            | type                                      |
      | environment      | SoftwareCommunitiesPlugin::SoftwaresBlock |

  Scenario: Change software block to generic software block
    Given I go to /admin/environment_design
    And I follow "Edit" within ".block.software-communities-plugin_softwares-block"
    When I select "Generic" from "block_software_type"
    And I press "Save"
    Then I should see "Generic Software"

  Scenario: Change software block to generic software block
    Given I go to /admin/environment_design
    And I follow "Edit" within ".block.software-communities-plugin_softwares-block"
    When I select "Public" from "block_software_type"
    And I press "Save"
    Then I should see "Public Software"
