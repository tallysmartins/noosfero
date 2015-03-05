Feature: edit public software information
  As a user
  I want to add public software information to a software
  So that I can have software communities on my network

  Background:
    Given "SoftwareCommunitiesPlugin" plugin is enabled
    And SoftwareInfo has initial default values on database
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "SoftwareCommunitiesPlugin"
    And I press "Save changes"
    And I go to /myprofile/mpog-admin
    And I follow "Create a new software"
    And I fill in "community_name_id" with "basic software"
    And I fill in "software_info_finality" with "basic software finality"
    And I type in "gp" in autocomplete list "#license_info_version" and I choose "GPL-2"
    And I press "Create"

  @selenium
  Scenario: Show SoftwareLangue fields when click in New Language
    Given I go to /myprofile/basic-software/plugin/software_communities/edit_software
    When I follow "Specifications"
    And I follow "New language"
    And I should see "3" of this selector ".software-language-table"
    And I follow "Delete"
    Then I should see "2" of this selector ".software-language-table"
    #3 because one is always hidden

  @selenium
  Scenario: Show databasefields when click in New database
    Given I go to /myprofile/basic-software/plugin/software_communities/edit_software
    When I follow "Specifications"
    And I follow "New Database"
    And I should see "3" of this selector ".database-table"
    And I follow "Delete"
    Then I should see "2" of this selector ".database-table"
    #3 because one is always hidden

  @selenium
  Scenario: Software database name should be an autocomplete
    Given I go to /myprofile/basic-software/plugin/software_communities/edit_software
    When I follow "Specifications"
    And I follow "New Database"
    And I type in "my" in autocomplete list ".database_autocomplete" and I choose "MySQL"
    Then selector ".database_autocomplete" should have any "MySQL"

  @selenium
  Scenario: Software database name should be an autocomplete
    Given I go to /myprofile/basic-software/plugin/software_communities/edit_software
    When I follow "Specifications"
    And I follow "New language"
    And I type in "py" in autocomplete list ".language_autocomplete" and I choose "Python"
    Then selector ".database_autocomplete" should have any "Python"

  @selenium
  Scenario: Create software with all dynamic table fields filled
    Given I go to /myprofile/basic-software/plugin/software_communities/edit_software
    When I follow "Specifications"
    And I follow "New language"
    And I type in "py" in autocomplete list ".language_autocomplete" and I choose "Python"
    And I fill in "language__version" with "1.2.3"
    And I follow "New Database"
    And I type in "my" in autocomplete list ".database_autocomplete" and I choose "MySQL"
    And I fill in "database__version" with "4.5.6"
    Then I press "Save"
    And I follow "Software Info"
    And I follow "Specifications"
    And selector ".language_autocomplete" should have any "Python"
    And selector "#language__version" should have any "1.2.3"
    And selector ".database_autocomplete" should have any "MySQL"
    And selector "#database__version" should have any "4.5.6"

  @selenium
  Scenario: Message second step of creation in edit software community
    Given the following softwares
    | name          | finality      |
    | New Software  | some finality |
    And I go to /myprofile/new-software/profile_editor/edit
    Then I should see "Step 2/2 - Software Community Configuration"
    And I go to /myprofile/new-software/profile_editor/edit
    Then I should not see "Step 2/2 - Software Community Configuration"

  @selenium
  Scenario: Show license link when a license is selected
    Given I am on mpog-admin's control panel
    And I follow "Create a new software"
    And I fill in "community_name" with "another software"
    And I fill in "software_info_finality" with "another software finality"
    And I type in "gp" in autocomplete list "#license_info_version" and I choose "GPL-2"
    And I should see "Read license" within "#version_link"
    And I press "Create"
    And I go to another-software's control panel
    And I follow "Software Info"
    And I type in "gp" in autocomplete list "#license_info_version" and I choose "GPL-3"
    Then I should see "Read license" within "#version_link"
