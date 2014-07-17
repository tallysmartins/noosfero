require File.dirname(__FILE__) + '/../../../../test/test_helper'

class SearchPersonTest < ActiveSupport::TestCase

  def setup
    create_person("Jose_Augusto", "DF", "Gama", "jose_augusto@email.com")
    create_person("Maria_cunha", "RJ", "Rio de Janeiro", "maria_cunha@email.com")
    create_person("Joao_da_silva_costa_cunha", "RJ", "Rio de Janeiro", "joao_da_silva_costa_cunha@gemail.com")
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

  def create_person name, state, city, email
    user =  User::new
    user.login = name.downcase
    user.email = email
    user.secondary_email = "#{name}_secondary@email2.com"
    user.password = "adlasdasd"
    user.password_confirmation = "adlasdasd"
    user.save!

    user.person.name = name
    user.person.state = state
    user.person.city = city
    user.person.save!

    user.save!
  end

end