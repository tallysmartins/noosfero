Feature: rejected_organization_rating
  As an admin
  I want to see the rejected organization ratings
  So I can distinguish them from the accepted and pending ones

  Background:
    Given the environment domain is "localhost"
    And "OrganizationRatings" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "Organization Ratings"
    And I press "Save changes"
    And the following user
      | login      | name        |
      | joaosilva  | Joao Silva  |
      | mariasilva | Maria Silva |
    And the following communities
      | name             |
      | mycommunity      |
      | anothercommunity |
    And the following blocks
      | owner       | type                      |
      | mycommunity | OrganizationRatingsBlock  |
    And the following organization ratings
      | value | comment_body            | organization_name | user_login | task_status |
      | 5     | A first long test text  | mycommunity       | mariasilva | 3           |
      | 5     | A second long test text | mycommunity       | joaosilva  | 2           |

  @selenium
  Scenario: display the rejected comment text to an admin
    Given I am logged in as "admin_user"
    And I go to /profile/mycommunity
    And I should see "A first long test text" within ".ratings-list"
    And I should see "Comment rejected" within ".ratings-list"
    And I should see "A second long test text" within ".ratings-list"

  @selenium
  Scenario: display the rejected comment text to the comment owner
    Given I am logged in as "joaosilva"
    And I go to /profile/mycommunity
    And I should see "A first long test text" within ".ratings-list"
    And I should see "Comment rejected" within ".ratings-list"
    And I should see "A second long test text" within ".ratings-list"

  @selenium
  Scenario: do not display the rejected comment text to a regular user
    Given I am logged in as "mariasilva"
    And I go to /profile/mycommunity
    And I should see "A first long test text" within ".ratings-list"
    And I should not see "Comment rejected" within ".ratings-list"
    And I should not see "A second long test text" within ".ratings-list"
