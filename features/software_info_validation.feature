Feature:
  As a user
  I want to create a new software

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And SoftwareInfo has initial default values on database
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"

  @selenium
  Scenario: Do not show error message if all required fields are correctly filled
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test name"
    And I fill in "language__version" with "2.0.0"
    And I fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I fill in "software_info_operating_platform" with "test operating platform"
    And fill in "software_info_acronym" with "SFTW"
    And I press "Create"
    Then I should see "Manage my groups"

  Scenario: Show operating_platform errors if this field is blank
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And fill in "community_name" with "test"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And fill in "software_info_acronym" with "SFTW"
    And I press "Create"
    Then I should see "Operating platform can't be blank"

  Scenario: Do not show operating_platform errors if this field is not blank
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And fill in "software_info_operating_platform" with "test operating platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I press "Create"
    Then I should not see "Operating platform can't be blank"

  @selenium
  Scenario: Show software_langue errors if this Version is blank
  Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And fill in "community_name" with "test"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I press "Create"
    Then I should see "Software languages is invalid"

  Scenario: Show acronym errors if this field is blank
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And fill in "community_name" with "test"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I press "Create"
    Then I should see "Acronym can't be blank"

  @selenium
  Scenario: Show database_fields errors version is blank
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And fill in "community_name" with "test"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__operating_system" with "GNU"
    And I press "Create"
    Then I should see "Software databases is invalid"

  Scenario: Show acronym errors if this field has more than 8 characters
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And fill in "community_name" with "test"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "database__version" with "3.0"
    And I press "Create"
    And fill in "software_info_acronym" with "123456789"
    And I press "Create"
    Then I should see "Acronym can't have more than 8 characteres"

  Scenario: Show operating system errors if this field is not filled
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I press "Create"
    Then I should see "Operating system : at least one must be filled"

  @selenium
  Scenario: Show operating system errors if this field is not filled
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    Then I should not see "Operating system : at least one must be filled"

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
    Then I should see "3" of this selector ".software-language-table"
    #3 because one is always hidden

  @selenium
  Scenario: Show databasefields when click in New database
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Database"
    Then I should see "3" of this selector ".database-table"
    #3 because one is always hidden

  @selenium
  Scenario: Create software with libraries
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Library"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And I fill in "library__name" with "test library name"
    And I fill in "library__version" with "test library version"
    And I fill in "library__license" with "test library license"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Libraries"
    And selector ".library-table" should have any "test library name"
    And selector ".library-table" should have any "test library version"
    Then selector ".library-table" should have any "test library license"

  @selenium
  Scenario: Delete software libraries
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Library"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And I fill in "library__name" with "test name"
    And I fill in "library__version" with "test version"
    And I fill in "library__license" with "test license"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Libraries"
    And selector ".library-table" should have any "test name"
    And selector ".library-table" should have any "test version"
    And selector ".library-table" should have any "test license"
    And I follow "Delete"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And I should not see "test name" within "#library__name"
    And I should not see "test version" within "#library__version"
    Then I should not see "test license" within "#library__license"

  @selenium
  Scenario: Crete software libraries on software edit
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I follow "New Library"
    And I fill in "library__name" with "test name"
    And I fill in "library__version" with "test version"
    And I fill in "library__license" with "test license"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Libraries"
    And selector ".library-table" should have any "test name"
    And selector ".library-table" should have any "test version"
    Then selector ".library-table" should have any "test license"

  @selenium
  Scenario: Edit software libraries on software edit
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I follow "New Library"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And I fill in "library__name" with "test name"
    And I fill in "library__version" with "test version"
    And I fill in "library__license" with "test license"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Libraries"
    And selector ".library-table" should have any "test name"
    And selector ".library-table" should have any "test version"
    And selector ".library-table" should have any "test license"
    And I follow "New Library"
    And I fill in "library__name" with "new name"
    And I fill in "library__version" with "new version"
    And I fill in "library__license" with "new license"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And selector ".library-table" should have any "new name"
    And selector ".library-table" should have any "new version"
    Then selector ".library-table" should have any "new license"

  @selenium
  Scenario: change license field
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And I select "GPL-2" from "license_info_version"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I select "GPL-3" from "version"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    Then I should see "GPL-3"

  @selenium
  Scenario: license link appears on the create software page
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And I fill in "software_info_operating_platform" with "test platform"
    And I select "GPL-2" from "license_info_version"
    Then I should see "www.gpl2.com" within "#version_link"

  @selenium
  Scenario: license link changes if the user choose a different license
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And I fill in "software_info_operating_platform" with "test platform"
    And I select "GPL-2" from "license_info_version"
    And I should see "www.gpl2.com" within "#version_link"
    And I select "GPL-3" from "license_info_version"
    Then I should see "www.gpl3.com" within "#version_link"

  @selenium
  Scenario: Crete software with Language
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Programming Languages"
    And selector ".software-language-table" should have any "2.0.0"
    Then selector ".software-language-table" should have any "Linux"

  @selenium
  Scenario: Edit softwareLanguage on profile editor
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Programming Languages"
    And selector ".software-language-table" should have any "2.0.0"
    And selector ".software-language-table" should have any "Linux"
    And I select "Python" from "language__programming_language_id"
    And fill in "language__version" with "3.2"
    And fill in "language__operating_system" with "GNU"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And selector ".software-language-table" should have any "Python"
    And selector ".software-language-table" should have any "3.2"
    Then selector ".software-language-table" should have any "GNU"

  @selenium
  Scenario: Adding new softwareLanguage on profile editor
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Programming Languages"
    And selector ".software-language-table" should have any "2.0.0"
    And selector ".software-language-table" should have any "Linux"
    And I follow "New language"
    And I click on the first button with class ".delete-dynamic-table"
    And I click on table number "2" selector ".software-language-table" and select the value "Python"
    And I fill with "4.3" in field with name "language[][version]" of table number "2" with class ".software-language-table"
    And I fill with "Windows" in field with name "language[][operating_system]" of table number "2" with class ".software-language-table"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And selector ".software-language-table" should have any "Python"
    And selector ".software-language-table" should have any "4.3"
    Then selector ".software-language-table" should have any "Windows"

  @selenium
  Scenario: Edit softwareDatabase on profile editor
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.0"
    And I fill in "database__operating_system" with "GNU"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Databases"
    And selector ".database-table" should have any "3.0"
    And selector ".database-table" should have any "GNU"
    And I select "PostgreSQL" from "database__database_description_id"
    And fill in "database__version" with "3.2"
    And fill in "database__operating_system" with "Linux"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And selector ".database-table" should have any "PostgreSQL"
    And selector ".database-table" should have any "3.2"
    Then selector ".database-table" should have any "Linux"

  @selenium
  Scenario: Delete softwareDatabase on profile editor
    Given I go to admin_user's control panel
    And I follow "Manage my groups"
    And I follow "Create a new software"
    And I fill in "community_name" with "test123"
    And fill in "software_info_acronym" with "SFTW"
    And I fill in "software_info_operating_platform" with "test platform"
    And fill in "language__version" with "2.0.0"
    And fill in "language__operating_system" with "Linux"
    And I fill in "database__version" with "3.5"
    And I fill in "database__operating_system" with "Solaris"
    And I fill in "operating_system__version" with "3.0"
    And I press "Create"
    And I go to /myprofile/test123/profile_editor/edit
    And I should see "Databases"
    And selector ".database-table" should have any "3.5"
    And selector ".database-table" should have any "Solaris"
    And I follow "New Database"
    And I click on table number "2" selector ".database-table" and select the value "MariaDB"
    And I fill with "4.3" in field with name "database[][version]" of table number "2" with class ".database-table"
    And I fill with "Windows" in field with name "database[][operating_system]" of table number "2" with class ".database-table"
    And I click on the first button with class ".database-table .delete-dynamic-table"
    And I press "Save"
    And I go to /myprofile/test123/profile_editor/edit
    And selector ".database-table" should have any "MariaDB"
    And selector ".database-table" should have any "4.3"
    And selector ".database-table" should have any "Windows"
    And I should not see "4th Dimension"
    And I should not see "3.5"
    And I should not see "Solaris"