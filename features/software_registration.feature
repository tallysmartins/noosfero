Feature: software registration
  As a user
  I want to create a new software
  So that I can have software communities on my network

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And SoftwareInfo has initial default values on database
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"

  @selenium
  Scenario: Show SoftwareLangue fields when click in New Language
    Given I go to /myprofile/mpog-admin
    And I follow "Create a new software"
    And I fill in "community_name" with "basic software"
    And I fill in "software_info_finality" with "basic software finality"
    And I press "Create"
    And I follow "Public Software"
    And I follow "New language"
    And I should see "3" of this selector ".software-language-table"
    And I follow "Delete"
    Then I should see "2" of this selector ".software-language-table"
    #3 because one is always hidden

  @selenium
  Scenario: Show databasefields when click in New database
    Given I go to /myprofile/mpog-admin
    And I follow "Create a new software"
    And I fill in "community_name" with "basic software"
    And I fill in "software_info_finality" with "basic software finality"
    And I press "Create"
    And I follow "Public Software"
    And I follow "New Database"
    And I should see "3" of this selector ".database-table"
    And I follow "Delete"
    Then I should see "2" of this selector ".database-table"
    #3 because one is always hidden

  @selenium
  Scenario: Software database name should be an autocomplete
    Given I go to /myprofile/mpog-admin
    And I follow "Create a new software"
    And I fill in "community_name" with "basic software"
    And I fill in "software_info_finality" with "basic software finality"
    And I press "Create"
    And I follow "Public Software"
    And I follow "New Database"
    And I type in "my" into autocomplete list "database_autocomplete" and I choose "MySQL"
    And I fill in "database_autocomplete" with "Replace me with MySQL"
    And I fill in "database__version" with ""
    Then selector ".database_autocomplete" should have any "MySQL"

  @selenium
  Scenario: Create software with all dynamic table fields filled
    Given I go to /myprofile/mpog-admin
    And I follow "Create a new software"
    And I fill in "community_name" with "basic software"
    And I fill in "software_info_finality" with "basic software finality"
    And I press "Create"
    And I follow "Public Software"
    And I follow "New language"
    And I fill in "language__version" with "1.2.3"
    And I fill in "language__operating_system" with "Unix"
    And I follow "New Database"
    And I type in "my" into autocomplete list "database_autocomplete" and I choose "MySQL"
    And I fill in "database__version" with "4.5.6"
    And I fill in "database__operating_system" with "Unix"
    And I press "Save"
    And I follow "Software Info"
    And I follow "Public Software"
    And selector "#language__version" should have any "1.2.3"
    And selector "#language__operating_system" should have any "Unix"
    And selector ".database_autocomplete" should have any "MySQL"
    And selector "#database__version" should have any "4.5.6"
    Then selector "#database__operating_system" should have any "Unix"
