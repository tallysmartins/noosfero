Feature: Institution Field
  As a user
  I want to update my update my user data
  So I can maintain my personal data updated

  Background:
    Given "GovUserPlugin" plugin is enabled
    And "SoftwareCommunitiesPlugin" plugin is enabled
    And the following users
      | login | name        |
      | joao  | Joao Silva  |
    And I am logged in as admin
    And I go to /admin/environment_themes/set/noosfero-spb-theme
    And I go to /admin/plugins
    And I check "GovUserPlugin"
    And I check "SoftwareCommunitiesPlugin"
    And I press "Save changes"
    And feature "skip_new_user_email_confirmation" is enabled on environment
    And I go to /admin/features/manage_fields
    And I check "person_fields_country_active"
    And I check "person_fields_state_active"
    And I check "person_fields_city_active"
    And I press "Save changes"
    And Institutions has initial default values on database
    And the following public institutions
      | name                       | acronym | country | state | city       | cnpj               | juridical_nature | governmental_power | governmental_sphere | corporate_name |
      | Ministerio das Cidades     | MC      | BR      | Distrito Federal    | Gama       | 58.745.189/0001-21 | Autarquia        | Executivo          | Federal             | Ministerio das Cidades |
      | Governo do DF              | GDF     | BR      | Distrito Federal    | Taguatinga | 12.645.166/0001-44 | Autarquia        | Legislativo        | Federal             | Governo do DF |
      | Ministerio do Planejamento | MP      | BR      | Distrito Federal    | Brasilia   | 41.769.591/0001-43 | Autarquia        | Judiciario         | Federal             | Ministerio do Planejamento |

	@selenium
  Scenario: Go to control panel when clicked on 'Complete your profile' link
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Complete your profile"
    Then I should see "Profile settings for "

  @selenium
  Scenario: Verify text information to use governmental e-mail
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Edit Profile"
    Then I should see "If you work in a public agency use your government e-Mail"

  @selenium
  Scenario: Add more then one instituion on profile editor
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Edit Profile"
    And I type in "Minis" in autocomplete list "#input_institution" and I choose "Ministerio do Planejamento"
    And I follow "Add institution"
    And I type in "Gover" in autocomplete list "#input_institution" and I choose "Governo do DF"
    And I follow "Add institution"
    Then I should see "Ministerio do Planejamento"
    And I should see "Governo do DF"

  @selenium
  Scenario: Verify if field 'city' is shown when Brazil is selected
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Edit Profile"
    Then I should see "City"

  @selenium
  Scenario: Verify if field 'city' does not appear when Brazil is not selected as country
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Edit Profile"
    And I select "United States" from "profile_data_country"
    Then I should not see "City" within ".type-text"

  @selenium
  Scenario: Show message of institution not found
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Edit Profile"
    And I fill in "input_institution" with "Some Nonexistent Institution"
    And I sleep for 1 seconds
    Then I should see "No institution found"

  @selenium
  Scenario: Does not suggest institution that already exists
    Given I am logged in as "joao"
    And I am on joao's control panel
    When I follow "Edit Profile"
    And I type in "Minis" in autocomplete list "#input_institution" and I choose "Ministerio do Planejamento"
    And I follow "Add institution"
    And I fill in "input_institution" with "Minis"
    And I sleep for 1 seconds
    Then I should not see "Ministerio do Planejamento" within "ul.ui-autocomplete"
