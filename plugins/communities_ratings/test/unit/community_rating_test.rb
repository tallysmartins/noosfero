require File.expand_path(File.dirname(__FILE__)) + '/../../../../test/test_helper'

class CommunityRatingTest < ActiveSupport::TestCase
  test "The value must be between 1 and 5" do
    community_rating1 = CommunityRating.new :value => -1
    community_rating2 = CommunityRating.new :value => 6

    assert_equal false, community_rating1.valid?
    assert_equal false, community_rating2.valid?

    assert_equal true, community_rating1.errors[:value].include?("must be between 1 and 5")
    assert_equal true, community_rating2.errors[:value].include?("must be between 1 and 5")

    community_rating1.value = 1
    community_rating1.valid?

    community_rating2.value = 5
    community_rating2.valid?

    assert_equal false, community_rating1.errors[:value].include?("must be between 1 and 5")
    assert_equal false, community_rating2.errors[:value].include?("must be between 1 and 5")
  end

  test "Create task for create a rating comment" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)

    community_rating = CommunityRating.create!(
        :value => 3,
        :person => person,
        :community => community
    )

    create_community_rating_comment = CreateCommunityRatingComment.create!(
      :requestor => person,
      :source => community,
      :community_rating => community_rating,
      :organization => community
    )

    assert community.tasks.include?(create_community_rating_comment)
  end

    test "Check comment message when Task status = ACTIVE" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)


    community_rating = CommunityRating.create!(
        :value => 3,
        :person => person,
        :community => community
    )

    create_community_rating_comment = CreateCommunityRatingComment.create!(
      :requestor => person,
      :source => community,
      :community_rating => community_rating,
      :organization => community
    )
    assert_equal 1, create_community_rating_comment.status
    message = "Comment waiting for approval"
    assert_equal message, community_rating.get_comment_message
  end

  test "Check comment message when Task status = CANCELLED" do
    person = create_user('molly').person
    person.email = "person@email.com"
    person.save!

    community = fast_create(Community)
    community.add_admin(person)


    community_rating = CommunityRating.create!(
        :value => 3,
        :person => person,
        :community => community
    )

    create_community_rating_comment = CreateCommunityRatingComment.create!(
      :requestor => person,
      :source => community,
      :community_rating => community_rating,
      :organization => community
    )
    create_community_rating_comment.cancel
    assert_equal 2, create_community_rating_comment.status
    message = "Comment rejected"
    assert_equal message, community_rating.get_comment_message
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

    community_rating = CommunityRating.create!(
        :value => 3,
        :person => person,
        :community => community,
        :comment => comment
    )

    create_community_rating_comment = CreateCommunityRatingComment.create!(
          :body => comment.body,
          :requestor => community_rating.person,
          :source => community_rating.community,
          :community_rating => community_rating,
          :organization => community_rating.community
      )

    create_community_rating_comment.finish
    assert_equal 3, create_community_rating_comment.status
    message = "regular comment"
    assert_equal message, community_rating.get_comment_message
  end


  test "Should calculate community's rating average" do
    community = fast_create Community
    p1 = fast_create Person, :name=>"Person 1"
    p2 = fast_create Person, :name=>"Person 2"
    p3 = fast_create Person, :name=>"Person 3"

    CommunityRating.create! :value => 2, :community => community, :person => p1
    CommunityRating.create! :value => 3, :community => community, :person => p2
    CommunityRating.create! :value => 5, :community => community, :person => p3

    assert_equal 3, CommunityRating.average_rating(community)

    p4 = fast_create Person, :name=>"Person 4"
    CommunityRating.create! :value => 4, :community => community, :person => p4

    assert_equal 4, CommunityRating.average_rating(community)
  end
end
