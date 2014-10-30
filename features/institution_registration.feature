Feature: Institution Field
  As a user
  I want to sign up resgistring my institution
  So others users can use it

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And Institutions has initial default values on database
    And I am logged in as mpog_admin

  @selenium
  Scenario: Show new institution fields when clicked in create new institution
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I should see "New Institution"
    And I should see "Name"
    And I should see "State"
    And I should see "City"
    And I should see "Country"
    And I should see "CNPJ"
    And I should see "Public Institution"
    And I choose "Public Institution"
    And I should see "Acronym"
    And I should see "Governmental Power:"
    Then I should see "Governmental Sphere:"

   @selenium
   Scenario: Show new institution fields when private institution is selected
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I should see "New Institution"
    And I should see "Name"
    And I should see "State"
    And I should see "City"
    And I should see "Country"
    And I should see "CNPJ"
    And I should see "Private Institution"
    And I choose "Private Institution"
    Then I should see "Fantasy name"

  @selenium
  Scenario: Create new public institution when all required fields are filled.
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I fill in "community_name" with "Institution Name"
    And I fill in "institutions_cnpj" with "00.000.000/0001-00"
    And I select "Brazil" from "community_country"
    And I fill in "community_state" with "DF"
    And I fill in "community_city" with "Brasilia"
    And I choose "Public Institution"
    And I select "Executivo" from "institutions_governmental_power"
    And I select "Federal" from "institutions_governmental_sphere"
    And I select "Autarquia" from "institutions_juridical_nature"
    And I follow "Save"
    Then I should see "Institution Name"

  @selenium
  Scenario: Create new private institution when all required fields are filled
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I fill in "community_name" with "Institution Name"
    And I fill in "institutions_cnpj" with "00.000.000/0001-00"
    And I select "Brazil" from "community_country"
    And I fill in "community_state" with "DF"
    And I fill in "community_city" with "Brasilia"
    And I choose "Private Institution"
    And I follow "Save"
    Then I should see "Institution Name"
      
  @selenium
  Scenario: Don't create an institution when name and cpnj are not filled
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I choose "Private Institution"
    And I fill in "institutions_acronym" with "Teste"
    And I select "Brazil" from "community_country"
    And I fill in "community_state" with "DF"
    And I fill in "community_city" with "Brasilia"
    And I follow "Save"
    Then I should see "Institution could not be created!"

  @selenium
  Scenario: Don't Create new institution when a governamental field is not filled
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I fill in "community_name" with "Institution Name"
    And I fill in "institutions_cnpj" with "00.000.000/0001-00"
    And I select "Brazil" from "community_country"
    And I fill in "community_state" with "DF"
    And I fill in "community_city" with "Brasilia"
    And I choose "Public Institution"
    And I follow "Save"
    Then I should see "Institution could not be created!"

  @selenium
  Scenario: Don't Create new institution when no field is filled
    Given I follow "Edit Profile"
    When I follow "Create new institution"
    And I choose "Public Institution"
    And I follow "Save"
    Then I should see "Institution could not be created!"
