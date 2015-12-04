require 'test_helper'
require File.dirname(__FILE__) + '/../../lib/ext/search_helper.rb'

class SearchHelperTest < ActiveSupport::TestCase

  include SearchHelper

  should "return communities list with relevance by nickname" do
    communities_list = []
    communities_list << Community.create(:name => "Help One", :nickname => "need")
    communities_list << Community.create(:name => "Need Two", :nickname => "help")
    communities_list << Community.create(:name => "Help Three", :nickname => "need")
    communities_list << Community.create(:name => "Need Four", :nickname => "help")

    relevanced_list = sort_by_relevance(communities_list, "need") { |community| [community.nickname] }

    assert_equal relevanced_list[0].nickname, "need"
    assert_equal relevanced_list[1].nickname, "need"
    assert_equal relevanced_list[2].nickname, "help"
    assert_equal relevanced_list[3].nickname, "help"
  end

  should "return communities list with relevance by name" do
    communities_list = []
    communities_list << Community.create(:name => "Help One", :nickname => "need")
    communities_list << Community.create(:name => "Need Two", :nickname => "help")
    communities_list << Community.create(:name => "Help Three", :nickname => "need")
    communities_list << Community.create(:name => "Need Four", :nickname => "help")

    relevanced_list = sort_by_relevance(communities_list, "need") { |community| [community.name] }

    assert relevanced_list[0].name.include?("Need")
    assert relevanced_list[1].name.include?("Need")
    assert relevanced_list[2].name.include?("Help")
    assert relevanced_list[3].name.include?("Help")
  end

  should "return communities list with relevance by nickname first and custom_header second" do
    communities_list = []
    communities_list << Community.create(:name => "Help One", :nickname => "need", :custom_header => "help")
    communities_list << Community.create(:name => "Need Two", :nickname => "help", :custom_header => "need")
    communities_list << Community.create(:name => "Help Three", :nickname => "need", :custom_header => "help")
    communities_list << Community.create(:name => "Need Four", :nickname => "help", :custom_header => "help")

    relevanced_list = sort_by_relevance(communities_list, "need") { |community| [community.custom_header, community.nickname] }

    assert relevanced_list[0].nickname.include?("need")
    assert relevanced_list[1].nickname.include?("need")
    assert relevanced_list[2].custom_header.include?("need")
    assert relevanced_list[3].custom_header.include?("help")
  end

end
