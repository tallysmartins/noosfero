Feature: rate_community
  As an admin
  I want to see a warning in the task if a software already has a rating related to an specific institution
  So it will be clear when the saved value will be updated

  Background:
    Given the environment domain is "localhost"
    And "OrganizationRatings" plugin is enabled
    And "SoftwareCommunities" plugin is enabled
    And "GovUser" plugin is enabled
    And I am logged in as mpog_admin
    And I go to /admin/plugins
    And I check "Organization Ratings"
    And I check "GovUserPlugin"
    And I check "SoftwareCommunitiesPlugin"
    And I press "Save changes"
    And the following user
      | login     | name       |
      | joaosilva | Joao Silva |
    And the following softwares
      | name        | public_software | finality                |
      | mycommunity | true            | basic software finality |
      | anothercommunity | true            | basic software finality |
    And the following blocks
      | owner       | type                |
      | mycommunity | OrganizationRatingsBlock  |
    And Institutions has initial default values on database
    And the following public institutions
      | name                       | acronym | country | state | city       | cnpj               | juridical_nature | governmental_power | governmental_sphere | corporate_name |
      | Ministerio das Cidades     | MC      | BR      | Distrito Federal    | Gama       | 58.745.189/0001-21 | Autarquia        | Executivo          | Federal             | Ministerio das Cidades |
      | Ministerio do Planejamento | MP      | BR      | Distrito Federal    | Brasilia   | 41.769.591/0001-43 | Autarquia        | Judiciario         | Federal             | Ministerio do Planejamento |

  Scenario: display message on task when a rating with the same institution exists on the same software
    Given the following organization ratings
      | value | organization_name | user_login | institution_name       | task_status |
      | 5     | mycommunity       | joaosilva  | Ministerio das Cidades | 3           |
      | 4     | mycommunity       | joaosilva  | Ministerio das Cidades | 1           |
    And I go to mycommunity's control panel
    And I follow "Process requests" within ".pending-tasks"
    And I choose "Accept" within ".task_decisions"
    Then I should see "This institution already has an accepted rating" in the page

  Scenario: do not display message on task when a rating with the same institution does not exist on the same software
    Given the following organization ratings
      | value | organization_name | user_login | institution_name           | task_status |
      | 5     | mycommunity       | joaosilva  | Ministerio das Cidades     | 3           |
      | 4     | mycommunity       | joaosilva  | Ministerio do Planejamento | 1           |
    And I go to mycommunity's control panel
    And I follow "Process requests" within ".pending-tasks"
    And I choose "Accept" within ".task_decisions"
    Then I should not see "This instiution already has an accepted rating" within ".task_box"

  Scenario: do not display message on task when a rating with the same institution exist on different softwares
    Given the following organization ratings
      | value | organization_name | user_login | institution_name       | task_status |
      | 5     | mycommunity       | joaosilva  | Ministerio das Cidades | 3           |
      | 4     | anothercommunity  | joaosilva  | Ministerio das Cidades | 1           |
    And I go to anothercommunity's control panel
    And I follow "Process requests" within ".pending-tasks"
    And I choose "Accept" within ".task_decisions"
    Then I should not see "This instiution already has an accepted rating" within ".task_box"
