Feature: edit adherent fields
  As a user
  I want to edit adherent fields
  to mantain my public software up to date.

  Background:
    Given "SoftwareCommunitiesPlugin" plugin is enabled
    And the following users
      | login      | name        | email                  |
      | joaosilva  | Joao Silva  | joaosilva@example.com  |
      | mariasilva | Maria Silva | mariasilva@example.com |
    And the following softwares
      | name           | public_software | finality                | owner     |
      | basic software | true            | basic software finality | joaosilva |
    And SoftwareInfo has initial default values on database
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "SoftwareCommunitiesPlugin"
    Then I press "Save changes"

  Scenario: Disable public software checkbox to non environment admin users
    Given I am logged in as "joaosilva"
    And I go to /myprofile/basic-software/plugin/software_communities/edit_software
    And I follow "Specifications"
    Then the "#software_public_software" button should be disabled

  Scenario: Enable public software checkbox to admin users
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/software_communities/edit_software
    And I follow "Specifications"
    Then the "#software_public_software" button should be enabled

  @selenium
  Scenario: Show adherent fields when checkbox are checked
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/software_communities/edit_software
    And I follow "Specifications"
    And I uncheck "software[public_software]"
    And I check "software[public_software]"
    Then I should see "Adherent to e-ping ?"

  @selenium
  Scenario: Don't show adherent fields when checkbox are not checked
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/software_communities/edit_software
    And I follow "Specifications"
    And I check "software[public_software]"
    And I uncheck "software[public_software]"
    Then I should not see "Adherent to e-ping ?"
