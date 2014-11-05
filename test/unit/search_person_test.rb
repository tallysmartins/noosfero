require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/plugin_test_helper'


class SearchPersonTest < ActiveSupport::TestCase
  include PluginTestHelper
  def setup
    create_person("Jose_Augusto", "jose_augusto@email.com", "aaaaaaa", "aaaaaaa", "jose_silva@email.com", "DF", "Gama")
    create_person("Maria_cunha", "maria_cunha@email.com", "aaaaaaa", "aaaaaaa", "maria_silva@email.com" , "RJ", "Rio de Janeiro")
    create_person("Joao_da_silva_costa_cunha", "joao_da_silva_costa_cunha@email.com", "aaaaaaa", "aaaaaaa", "joao_cunha@email.com" ,"RJ", "Rio de Janeiro")
  end

  def teardown
    Person.destroy_all
  end

  should "Find people with Jo in name" do
    people_list = Person.search("Jo")

    assert_equal 2, people_list.count
  end

  should "Find people with RJ in state" do
    people_list = Person.search("", "RJ")

    assert_equal 2, people_list.count
  end

  should "Find people with Gama in city" do
    people_list = Person.search("", "", "Gama")

    assert_equal 1, people_list.count
  end

  should "Find people with jose in email" do
    people_list = Person.search("", "", "", "jose")

    assert_equal 1, people_list.count
  end

  should "Find people with Jo in name and j in email" do
    people_list = Person.search("Jo", "", "", "j")

    assert_equal 2, people_list.count
  end

  should "Find people with Ma in name and RJ in state and Rio in city and ma in email" do
    people_list = Person.search("Ma", "RJ", "Rio", "ma")

    assert_equal 1, people_list.count
  end

end
