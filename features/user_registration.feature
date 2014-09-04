Feature: User Registration

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And I go to /admin/features/manage_fields
    And I check "person_fields_country_active"
    And I check "person_fields_country_required"
    And I check "person_fields_country_signup"
    And I check "person_fields_state_active"
    And I check "person_fields_state_required"
    And I check "person_fields_state_signup"
    And I check "person_fields_city_active"
    And I check "person_fields_city_required"
    And I check "person_fields_city_signup"
    And I press "Save changes"
    And the following blocks
      | owner       | type       |
      | environment | LoginBlock |
    And I go to /account/logout


  @selenium
  Scenario: Successful autocomplete with part of the institution name and adding institution
    Given I go to /account/signup
    And Institutions has initial default values on database
    And the following public institutions
      | name                       | acronym | country | state | city       | cnpj               | juridical_nature | governmental_power | governmental_sphere |
      | Ministerio das Cidades     | MC      | BR      | DF    | Gama       | 58.745.189/0001-21 | Autarquia        | Executivo          | Federal             |
      | Governo do DF              | GDF     | BR      | DF    | Taguatinga | 12.645.166/0001-44 | Autarquia        | Legislativo        | Federal             |
      | Ministerio do Planejamento | MP      | BR      | DF    | Brasilia   | 41.769.591/0001-43 | Autarquia        | Judiciario         | Federal             |
    And I type in "Minis" into autocomplete list "input_institution" and I choose "Ministerio do Planejamento"
    And I follow "Add new institution"
    Then I should see "Ministerio do Planejamento" within ".institutions_added"

  @selenium
  Scenario: Successfull autocomplete with institution acronym
    Given I go to /account/signup
    And Institutions has initial default values on database
    And the following public institutions
      | name                       | acronym | country | state | city       | cnpj               | juridical_nature | governmental_power | governmental_sphere |
      | Ministerio das Cidades     | MC      | BR      | DF    | Gama       | 58.745.189/0001-21 | Autarquia        | Executivo          | Federal             |
      | Governo do DF              | GDF     | BR      | DF    | Taguatinga | 12.645.166/0001-44 | Autarquia        | Legislativo        | Federal             |
      | Ministerio do Planejamento | MP      | BR      | DF    | Brasilia   | 41.769.591/0001-43 | Autarquia        | Judiciario         | Federal             |
    And I type in "MP" into autocomplete list "input_institution" and I choose "Ministerio do Planejamento"
    And I follow "Add new institution"
    Then I should see "Ministerio do Planejamento" within ".institutions_added"
    

  @selenium
  Scenario: Remove the incomplete resgistration percentage message
    Given I go to /account/signup
    And I fill in the following within ".no-boxes":
      | e-Mail                | josesilva@gmail.com    |
      | Password              | secret                 |
      | Password confirmation | secret                 |
      | Full name             | José da Silva          |
      | State                 | Bahia                  |
      | City                  | Salvador               |
      | Secondary e-Mail      | josesilva@example.com  |
    And I select "Brazil" from "profile_data[country]"
    And I fill in "Username" with "josesilva"
    And wait for the captcha signup time
    And I press "Create my account"
    When José da Silva's account is activated
    And I go to login page
    And I fill in "Username" with "josesilva"
    And I fill in "Password" with "secret"
    And I press "Log in"
    And I click on anything with selector ".hide-incomplete-percentage"
    Then I should not see "Complete Profile: 37%"

  @selenium
  Scenario: When the user logged in and hide link of imcomplete percentage and user log out and log in again, the percentage registration link must appear
    Given the following users
      | login | name        | email             | country | state | city     |
      | maria | Maria Silva | maria@example.com | Brazil  | DF    | Brasilia |
    When I am logged in as "maria"
    And I go to /profile/maria
    And I should see "Complete Profile:"
    And I click on anything with selector ".hide-incomplete-percentage"
    And I should not see "Complete Profile"
    And I follow "Logout"
    And I am logged in as "maria"
    And I go to /profile/maria
    Then I should see "Complete Profile:"

  @selenium
  Scenario: When the user logged in and hide link of imcomplete percentage and user update page, the percentage registration link must not appear
    Given the following users
      | login | name        | email             | country | state | city     |
      | maria | Maria Silva | maria@example.com | Brazil  | DF    | Brasilia |
    When I am logged in as "maria"
    And I go to /profile/maria
    And I should see "Complete Profile"
    And I click on anything with selector ".hide-incomplete-percentage"
    And I should not see "Complete Profile"
    And I go to /myprofile/maria/profile_editor/edit
    And I should not see "Complete Profile"
    And I go to /profile/maria
    Then I should not see "Complete Profile"

