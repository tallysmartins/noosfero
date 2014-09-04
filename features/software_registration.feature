Feature: software registration
  As a user
  I want to create a new software
  So that I can have software communities on my network

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And SoftwareInfo has initial default values on database
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"

  Scenario: Show library fields when click in New Library
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Library"
    Then I should see "Name"
    Then I should see "Version"
    Then I should see "License"

  @selenium
  Scenario: Show SoftwareLangue fields when click in New Language
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New language"
    And I should see "3" of this selector ".software-language-table"
    And I follow "Delete"
    Then I should see "2" of this selector ".software-language-table"
    #3 because one is always hidden

  @selenium
  Scenario: Show databasefields when click in New database
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Database"
    And I should see "3" of this selector ".database-table"
    And I follow "Delete"
    Then I should see "2" of this selector ".database-table"
    #3 because one is always hidden

  @selenium
  Scenario: Delete software libraries
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Library"
    And I should see "2" of this selector ".library-table"
    And I follow "Delete"
    Then I should see "1" of this selector ".library-table"

