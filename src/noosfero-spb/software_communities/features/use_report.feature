Feature: Use report
  As a user
  I want to make a use report of a software
  to give my feedback about a software.

  Background:
    Given "GovUserPlugin" plugin is enabled
    Given "SoftwareCommunitiesPlugin" plugin is enabled
    Given "OrganizationRatings" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "SoftwareCommunitiesPlugin"
    And I check "GovUserPlugin"
    And I press "Save changes"
    And the following softwares
      | name      | public_software | finality      |
      | Noosfero  | true            | some finality |

  Scenario: Add Organization Ratings Block
    Given I go to Noosfero's control panel
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    And I choose "Organization Ratings"
    And I press "Add"
    Then I should see "Report your experiences"

  Scenario: Add Average Rating Block
    Given I go to Noosfero's control panel
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    And I choose "Organization Average Rating"
    And I press "Add"
    Then I should see "Be the first to rate!"

  @selenium
  Scenario: Test Additional Fields JavaScript
    Given I go to /profile/noosfero/plugin/organization_ratings/new_rating
    Then I should not see "Number of Beneficiaries"
    And I should not see "Saved resources"
    When I click on anything with selector "comments-additional-information"
    Then I should see "Number of Beneficiaries"
    And I should see "Saved resources"

   @selenium
   Scenario: Validate Use Report fields format
    Given Institutions has initial default values on database
    And the following public institutions
      | name                       | acronym | country | state | city       | cnpj               | juridical_nature | governmental_power | governmental_sphere | corporate_name |
      | Ministerio do Planejamento | MP      | BR      | Distrito Federal    | Brasilia   | 41.769.591/0001-43 | Autarquia        | Judiciario         | Federal             | Ministerio do Planejamento |
    And I go to Noosfero's control panel
    And I follow "Edit sideboxes"
    When I follow "Add a block"
    And I choose "Organization Ratings"
    And I press "Add"
    And I am on Noosfero's homepage
    And I follow "Rate Community"
    When I click on anything with selector "comments-additional-information"
    And I type in "Minis" in autocomplete list "#input_institution" and I choose "Ministerio do Planejamento"
    And I fill in "people_benefited_tmp" with "123123"
    And I fill in "saved_value_tmp" with "7654321"
    And I press "Save"
    Then I should see "Benefited People: 123,123"
    And I should see "Saved Resources: $76,543.21"
