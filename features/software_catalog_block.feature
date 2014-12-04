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
    And I go to /admin/environment_design
    And I follow "Add a block"
    And I choose "Search Softwares catalog"
    And I press "Add"
    And I go to /account/logout
    And the following users
      | login      | name        | email                  |
      | joaosilva  | Joao Silva  | joaosilva@example.com  |
    And I am logged in as "joaosilva"


  Scenario: successfull search
    Given I go to homepage 
    And I press "Search"
    Then I should see "Software Catalog"
