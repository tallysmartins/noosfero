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

  Scenario: Don't show public software checkbox to no enviroment admin
    Given I am logged in as "joaosilva"
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    Then I should not see "Is a public software"

  Scenario: Show public software checkbox no enviroment admin
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    Then I should see "Is a public software"

  Scenario: Show adherent fields when checkbox are checked
    Given I am logged in as mpog_admin
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    And I check "software[public_software]"
    And I press "Save"
    And I go to /myprofile/basic-software/plugin/mpog_software/edit_software
    And I follow "Specifications"
    Then I should see "Adherent to e-ping ?"


