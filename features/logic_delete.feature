Feature: deactivate user
  As a user
  I want to deactivate my account
  So I can reactivate my account later

  Background:
    Given "MpogSoftwarePlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "MpogSoftwarePlugin"
    And I press "Save changes"
    And I go to /account/logout
    And the following users
      | login      | name        | email                  |
      | joaosilva  | Joao Silva  | joaosilva@example.com  |
    And I am logged in as "joaosilva"

@selenium
  Scenario: successfull deactivation
    Given I go to joaosilva's control panel
    And I follow "Edit Profile"
    And I follow "Delete profile"
    And I follow "Yes, I am sure"
    Then I am not logged in
    When I go to /profile/joaosilva
    Then I should see "This profile is inaccessible."

@selenium
  Scenario: successfull reactivation of account
    Given I go to joaosilva's control panel
    And I follow "Edit Profile"
    And I follow "Delete profile"
    And I follow "Yes, I am sure"
    And I go to the homepage
    When I follow "Login"
    And I follow "New user"
    And I fill in the following within ".no-boxes":
      | e-Mail                | joaosilva@example.com |
      | Full name             | 123 |
    And I follow "Reactive account"
    And I fill in the following within ".no-boxes":
      | Username or Email     | joaosilva@example.com |
    And I press "Send instructions"
    Then I should see "An e-mail was just sent to your e-mail address"
