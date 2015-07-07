require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../../lib/ext/comments.rb'

class CommentsTest < ActiveSupport::TestCase

  def teardown
    Comment.destroy_all
  end

  should 'create comments with new fields' do
    @person = fast_create(Person)
    @article = Article.create(:profile => @person, :name => "Test")

    comment = Comment.new(:body => "Comment new", :author => @person, :people_benefited => 2, :saved_value => 38.5)
    assert comment.save
  end
end
