Feature: Institution Field
  As a user
  I want to update my update my user data
  So I can maintain my personal data updated

  Background:
    Given "GovUserPlugin" plugin is enabled
    And I am logged in as admin
    And I go to /admin/plugins
    And I check "GovUserPlugin"
    And I press "Save changes"
    And feature "skip_new_user_email_confirmation" is enabled on environment
    And I go to /admin/features/manage_fields
    And I check "person_fields_country_active"
    And I check "person_fields_state_active"
    And I check "person_fields_city_active"
    And I press "Save changes"
    And I am logged in as mpog_admin

  Scenario: Go to control panel when clicked on 'Complete your profile' link
    When I follow "Complete your profile"
    Then I should see "Profile settings for "
    And I should see "Personal information"

  @selenium
  Scenario: Verify text information to use governmental e-mail
    Given I follow "Edit Profile"
    Then I should see "If you work in a public agency use your government e-Mail"
