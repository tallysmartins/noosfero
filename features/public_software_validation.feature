Feature: edit adherent fields
  As a user
  I want to edit adherent fields
  to mantain my public software up to date.

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And the following users
      | login      | name        | email                  |
      | joaosilva  | Joao Silva  | joaosilva@example.com  |
      | mariasilva | Maria Silva | mariasilva@example.com |
    And SoftwareInfo has initial default values on database
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And I go to /myprofile/mpog-admin
    And I follow "Create a new software"
    And I fill in "community_name" with "basic software"
    And I fill in "software_info_finality" with "basic software finality"
    And I press "Create"

  Scenario: Disable public software checkbox to non admin users
    Given I am logged in as "joaosilva"
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    Then I should see "Public software" within ".public_software_disabled"

  Scenario: Enable public software checkbox to admin users
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    Then I should see "Public software" within ".public_software_enabled"

  @selenium
  Scenario: Show adherent fields when checkbox are checked
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    And I uncheck "software[public_software]"
    And I check "software[public_software]"
    Then I should see "Adherent to e-ping ?"

  @selenium
  Scenario: Don't show adherent fields when checkbox are not checked
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    And I check "software[public_software]"
    And I uncheck "software[public_software]"
    Then I should not see "Adherent to e-ping ?"



