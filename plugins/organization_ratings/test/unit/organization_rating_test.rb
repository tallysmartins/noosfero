require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'

class OrganizationRatingTest < ActiveSupport::TestCase

  def setup
    @person = fast_create(Person)
    @community = fast_create(Community)
    @adminuser = Person[create_admin_user(Environment.default)]
    @rating = fast_create(OrganizationRating, {:value => 1,
                                               :person_id => @person.id,
                                               :organization_id => @organization_id,
                                               :comment_rejected => true
                                              })
  end

  test "The value must be between 1 and 5" do
    organization_rating1 = OrganizationRating.new :value => -1
    organization_rating2 = OrganizationRating.new :value => 6

    assert_equal false, organization_rating1.valid?
    assert_equal false, organization_rating2.valid?

    assert_equal true, organization_rating1.errors[:value].include?("must be between 1 and 5")
    assert_equal true, organization_rating2.errors[:value].include?("must be between 1 and 5")

    organization_rating1.value = 1
    organization_rating1.valid?

    organization_rating2.value = 5
    organization_rating2.valid?

    assert_equal false, organization_rating1.errors[:value].include?("must be between 1 and 5")
    assert_equal false, organization_rating2.errors[:value].include?("must be between 1 and 5")
  end

  test "display rejected rating to env admin" do
    assert @rating.display_comment_to?(@adminuser)
  end

  test "display rejected rating to owner" do
    assert @rating.display_comment_to?(@person)
  end

  test "do not display rejected rating to regular user" do
    regular_person = fast_create(Person)
    assert_not @rating.display_comment_to?(@otherperson)
  end

  test "do not display rejected rating to not logged user" do
    assert_not @rating.display_comment_to?(nil)
  end

  test "display rejected warning to env admin" do
    assert @rating.display_rejected_message_to?(@adminuser)
  end

  test "display rejected warning to owner" do
    assert @rating.display_rejected_message_to?(@person)
  end

  test "do not display rejected warnimg to regular user" do
    regular_person = fast_create(Person)
    assert_not @rating.display_rejected_message_to?(@otherperson)
  end

  test "Create task for create a rating comment" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)

    organization_rating = OrganizationRating.create!(
        :value => 3,
        :person => person,
        :organization => community
    )

    create_organization_rating_comment = CreateOrganizationRatingComment.create!(
      :requestor => person,
      :organization_rating_id => organization_rating.id,
      :target => community
    )

    assert community.tasks.include?(create_organization_rating_comment)
  end

    test "Check comment message when Task status = ACTIVE" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)


    organization_rating = OrganizationRating.create!(
        :value => 3,
        :person => person,
        :organization => community
    )

    create_organization_rating_comment = CreateOrganizationRatingComment.create!(
      :requestor => person,
      :organization_rating_id => organization_rating.id,
      :target => community,
      :body => "sample comment"
    )
    assert_equal 1, create_organization_rating_comment.status
    message = "Comment waiting for approval"
    comment = Comment.find_by_id(create_organization_rating_comment.organization_rating_comment_id)
    assert_equal message, comment.body
  end

  test "Check comment message when Task status = CANCELLED" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)


    organization_rating = OrganizationRating.create!(
        :value => 3,
        :person => person,
        :organization => community
    )

    create_organization_rating_comment = CreateOrganizationRatingComment.create!(
      :requestor => person,
      :organization_rating_id => organization_rating.id,
      :target => community,
      :body => "sample comment"
    )
    create_organization_rating_comment.cancel
    assert_equal 2, create_organization_rating_comment.status
    message = "Comment rejected"
    comment = Comment.find_by_id(create_organization_rating_comment.organization_rating_comment_id)
    assert_equal "sample comment", comment.body
  end

  test "Check comment message when Task status = FINISHED" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)

    comment = Comment.create!(source: community,
                                                 body: "regular comment",
                                                 author: person)

    organization_rating = OrganizationRating.create!(
        :value => 3,
        :person => person,
        :organization => community,
        :comment => comment
    )

    create_organization_rating_comment = CreateOrganizationRatingComment.create!(
          :body => comment.body,
          :requestor => organization_rating.person,
          :organization_rating_id => organization_rating.id,
          :target => organization_rating.organization,
          :body => "sample comment"
      )

    create_organization_rating_comment.finish
    assert_equal 3, create_organization_rating_comment.status
    message = "sample comment"
    comment = Comment.find_by_id(create_organization_rating_comment.organization_rating_comment_id)
    assert_equal message, comment.body
  end


  test "Should calculate community's rating average" do
    community = fast_create Community
    p1 = fast_create Person, :name=>"Person 1"
    p2 = fast_create Person, :name=>"Person 2"
    p3 = fast_create Person, :name=>"Person 3"

    OrganizationRating.create! :value => 2, :organization => community, :person => p1
    OrganizationRating.create! :value => 3, :organization => community, :person => p2
    OrganizationRating.create! :value => 5, :organization => community, :person => p3

    assert_equal 3, OrganizationRating.average_rating(community)

    p4 = fast_create Person, :name=>"Person 4"
    OrganizationRating.create! :value => 4, :organization => community, :person => p4

    assert_equal 4, OrganizationRating.average_rating(community)
  end
end
