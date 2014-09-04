Feature: Institution Field
  As a user
  I want to update my update my user data
  So I can maintain my personal data updated

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And feature "skip_new_user_email_confirmation" is enabled on environment
    And I go to /account/logout
    And Institutions has initial default values on database
    And the following public institutions
      | name                       | acronym | country | state | city       | cnpj               | juridical_nature | governmental_power | governmental_sphere |
      | Ministerio das Cidades     | MC      | BR      | DF    | Gama       | 58.745.189/0001-21 | Autarquia        | Executivo          | Federal             |
      | Governo do DF              | GDF     | BR      | DF    | Taguatinga | 12.645.166/0001-44 | Autarquia        | Legislativo        | Federal             |
      | Ministerio do Planejamento | MP      | BR      | DF    | Brasilia   | 41.769.591/0001-43 | Autarquia        | Judiciario         | Federal             |
    And I go to /account/signup
    And Institutions has initial default values on database
    And I fill in the following within ".no-boxes":
      | e-Mail                | josesilva@nowitgo.com|
      | Username              | josesilva              |
      | Password              | secret                 |
      | Password confirmation | secret                 |
      | Full name             | José da Silva          |
      | Secondary e-Mail      | josesilva@example.com  |
    And wait for the captcha signup time
    And I follow "Add new institution"
    And I press "Create my account"
    Then José da Silva's account is activated
    
  @selenium
  Scenario: Add more then one instituion on profile editor
    Given I am on josesilva's control panel
    And I follow "Edit Profile"
    And I follow "Add new institution"
    And I type in "Minis" into autocomplete list "input_institution" and I choose "Ministerio do Planejamento"
    And I follow "Add new institution"
    And I type in "Gover" into autocomplete list "input_institution" and I choose "Governo do DF"
    And I follow "Add new institution"
    Then I should see "Ministerio do Planejamento" within ".institutions_added"
    And I should see "Governo do DF" within ".institutions_added"

