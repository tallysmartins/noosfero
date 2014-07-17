Feature: Mpog Search People
  As a user
  I want to search for people with one or more filter options
  So I can find another user

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And I go to /account/logout
    And the following users
      | login        | name         | state | city      | email                  |
      | josecunha    | Jose Cunha   | DF    | Gama      | jose.cunha@gmail.com   |
      | cunhajose    | Cunha Jose   | SP    | Guarulhos | cunha.jose@gmail.com   |
      | joaoperera   | Joao Perera  | NY    | New York  | joao.perera@gmail.com  |
      | mariaperera  | Maria Perera | NY    | New York  | maria.perera@gmail.com |

  Scenario: Search a person with name field
    Given I go to /search/people
    And I fill in "name" with "jo"
    And I press "Search"
    And I should see "Jose Cunha"
    Then I should see "Joao Perera"

  Scenario: Search a person with a state field
    Given I go to /search/people
    And I fill in "state" with "DF"
    And I press "Search"
    Then I should see "Jose Cunha" 

  Scenario: Search a person with a city field
    Given I go to /search/people
    And I fill in "city" with "Guarulhos"
    And I press "Search"
    Then I should see "Cunha Jose"

  Scenario: Search a person with a email field
    Given I go to /search/people
    And I fill in "email" with "jo"
    And I press "Search"
    And I should see "Jose Cunha"
    And I should see "Cunha Jose"
    Then I should see "Joao Perera"

  Scenario: Search a person with name and state fields
    Given I go to /search/people
    And I fill in "name" with "perera"
    And I fill in "state" with "NY"
    And I press "Search"
    And I should see "Maria Perera"
    Then I should see "Joao Perera"

  Scenario: Search a person with all fields
    Given I go to /search/people
    And I fill in "name" with "perera"
    And I fill in "state" with "NY"
    And I fill in "city" with "New"
    And I fill in "email" with "joao"
    And I press "Search"
    Then I should see "Joao Perera"