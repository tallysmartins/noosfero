Feature: rate_community
  As a user
  I want to be able rate a community
  So that users can see my feedback about that community

  Background:
    Given plugin "CommunitiesRatings" is enabled on environment
    Given the following user
      | login     | name       |
      | joaosilva | Joao Silva |
    And the following community
      | identifier  | name         |
      | mycommunity | My Community |
    And the following blocks
      | owner       | type                |
      | mycommunity | AverageRatingBlock  |
      | mycommunity | CommunitiesRatingsBlock  |
    And the environment domain is "localhost"
    And I am logged in as "joaosilva"

  @selenium
  Scenario: display rate button inside average block
    Given I am on mycommunity's homepage
    Then I should see "Rate this community" within ".average-rating-block"
    And I should see "Be the first to rate" within ".average-rating-block"

  @selenium
  Scenario: display rate button inside communities ratings block
    Given I am on mycommunity's homepage
    Then I should see "Rate Community" within ".make-report-block"

  @selenium
  Scenario: success load default stars
    Given I go to /profile/mycommunity/plugin/communities_ratings/new_rating
    Then The page should contain "[class='star-positive'][data-star-rate='1']"
    And The page should contain "[class='star-negative'][data-star-rate='2']"
    And The page should contain "[class='star-negative'][data-star-rate='3']"
    And The page should contain "[class='star-negative'][data-star-rate='4']"
    And The page should contain "[class='star-negative'][data-star-rate='5']"
    When I click within "star-positive"
    Then The page should contain "[class='star-positive'][data-star-rate='1']"
    And I should see "Rated as stars"

