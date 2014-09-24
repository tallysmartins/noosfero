Feature: deactivate software
  As a administrator of a software
  I want to be able to deactivate
  So that, if needed, I can reactivate it without loosing it's data

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
      And I am logged in as admin
      And I go to /admin/plugins
      And I check "MpogSoftwarePlugin"
      And I press "Save changes"
      And SoftwareInfo has initial default values on database

  @selenium
  Scenario: Deactivate a software
    Given the following software language
    | programing_language | version | operating_system |
    | Python              | 1.0     | Linux            |
    And the following software databases
    | database_name | version | operating_system |
    | PostgreSQL    | 1.0     | Linux            |
    And the following operating systems
    | operating_system_name | version | 
    | Debian                | 1.0     |                 
    And the following softwares
    | name  | acronym | operating_platform | software_language | software_database | operating_system| objectives | features |
    | teste | ts      | I dont know        | Python            | PostgreSQL        | Debian          | teste      | teste    | 
    And I go to /plugin/mpog_software/archive_software
    And I should see "teste"
    And I follow "Deactivate software"
    And I confirm the "Do you want to deactivate this software?" dialog
    And I go to /search/communities
    And I fill in "search-input" with "teste"
    And I press "Search"
    Then I should not see "teste" within "#search-results"

  @selenium
  Scenario: Activate a deactivated software
    Given the following software language
    | programing_language | version | operating_system |
    | Python              | 1.0     | Linux            |
    And the following software databases
    | database_name | version | operating_system |
    | PostgreSQL    | 1.0     | Linux            |
    And the following operating systems
    | operating_system_name | version | 
    | Debian                | 1.0     |                 
    And the following softwares
    | name  | acronym | operating_platform | software_language | software_database | operating_system| objectives | features |
    | teste | ts      | I dont know        | Python            | PostgreSQL        | Debian          | teste      | teste    |
   And I go to /plugin/mpog_software/archive_software
    And I should see "teste"
    And I follow "Deactivate software"
    And I confirm the "Do you want to deactivate this software?" dialog
    And I go to /search/communities
    And I fill in "search-input" with "teste"
    And I press "Search"
    And I should not see "Teste" within "#search-results"
    And I go to /plugin/mpog_software/archive_software
    And I should see "teste"
    And I follow "Activate Software"
    And I confirm the "Do you want to activate this software?" dialog
    And I go to /search/communities 
    And I fill in "search-input" with "teste"
    And I press "Search"
    Then I should see "teste" within ".search-profile-item"
