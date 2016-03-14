require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'
require(
  File.dirname(__FILE__) +
  '/../../../../app/controllers/public/search_controller'
)

class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < ActionController::TestCase
  include PluginTestHelper

  def setup
    @environment = Environment.default
    @environment.enabled_plugins = ['SoftwareCommunitiesPlugin']
    @environment.save

    @controller = SearchController.new
    @request = ActionController::TestRequest.new
    @request.stubs(:ssl?).returns(:false)
    @response = ActionController::TestResponse.new

    @licenses = [
      LicenseInfo.create(:version => "GPL - 1"),
      LicenseInfo.create(:version => "GPL - 2")
    ]

    create_software_categories

    @softwares = []

    @softwares << create_software_info("Software One", :acronym => "SFO", :finality => "Help")
    @softwares << create_software_info("Software Two", :acronym => "SFT", :finality => "Task")

    @softwares[0].community.categories << Category.first
    @softwares[1].community.categories << Category.last

    @softwares[0].license_info = @licenses.first
    @softwares[1].license_info = @licenses.last

    @softwares[0].save!
    @softwares[1].save!
  end

  def teardown
    SoftwareInfo.destroy_all
  end

  should "communities searches don't have software" do
    community = create_community("Community One")

    get :communities, :query => "One"

    assert_includes assigns(:searches)[:communities][:results], community
    assert_not_includes assigns(:searches)[:communities][:results], @softwares.first.community
  end

  should "software_infos search don't have community" do
     community = create_community("Community One")

     get :software_infos, :query => "One"

     assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
     assert_not_includes assigns(:searches)[:software_infos][:results], community
  end


  should "Don't have template in communities search result" do
    communities = []
    communities << create_community("Community One")
    communities << create_community("Community Two")

    community_template = create_community("Community Template")
    community_template.is_template = true
    community_template.visible = false
    community_template.save!

    get :communities, :query => "Comm"

    assert_not_includes(
      assigns(:searches)[:communities][:results],
      community_template
    )
  end

  should "software_infos search by category" do
    get(
      :software_infos,
      :query => "",
      :selected_categories_id => [Category.first.id]
    )

    assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
    assert_not_includes assigns(:searches)[:software_infos][:results], @softwares.last.community
  end

  should "return software_infos with category matching query" do
    some_category = Category.new(:name => "Health", :environment => @environment)
    @softwares[0].community.categories << some_category

    get(
      :software_infos,
      :query => "Health",
    )

    assert_includes assigns(:searches)[:software_infos][:results], @softwares[0].community
    assert_not_includes assigns(:searches)[:software_infos][:results], @softwares[1].community
  end

  should "software_infos search by sub category" do
    category = Category.create(:name => "Category", :environment => @environment)
    sub_category = Category.create(:name => "Sub Category", :environment => @environment, :parent_id => category.id)

    software = create_software_info "software 1"
    software.community.add_category sub_category

    software2 = create_software_info "software 2"
    software2.community.add_category category

    get(
      :software_infos,
      :query => "",
      :selected_categories_id => [category.id]
    )

    assert_includes assigns(:searches)[:software_infos][:results], software.community
    assert_includes assigns(:searches)[:software_infos][:results], software2.community
  end

  should "software_infos search softwares with one or more selected categories" do
    software = create_software_info("Software Two", :acronym => "SFT", :finality => "Task")
    software.save!

    get(
      :software_infos,
      :query => "",
      :selected_categories_id => [Category.all[0], Category.all[1]]
    )

    assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
    assert_includes assigns(:searches)[:software_infos][:results], @softwares.last.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software.community
  end


  should "software_infos search by programming language" do
    @softwares.first.software_languages << create_software_language("Python", "1.0")
    @softwares.last.software_languages << create_software_language("Java", "8.1")

    @softwares.first.save!
    @softwares.last.save!

    get(
      :software_infos,
      :query => "python",
    )

    assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
    assert_not_includes assigns(:searches)[:software_infos][:results], @softwares.last.community
  end

  should "software_infos search by database description" do
    @softwares.first.software_databases << create_software_database("MySQL", "1.0")
    @softwares.last.software_databases << create_software_database("Postgrees", "8.1")

    @softwares.first.save!
    @softwares.last.save!

    get(
      :software_infos,
      :query => "mysql",
    )

    assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
    assert_not_includes assigns(:searches)[:software_infos][:results], @softwares.last.community
  end

  should "software_infos search by finality" do
    get(
      :software_infos,
      :query => "help",
    )


    assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
    assert_not_includes assigns(:searches)[:software_infos][:results], @softwares.last.community
  end

  should "software_infos search by acronym" do
    get(
      :software_infos,
      :query => "SFO",
    )

    assert_includes assigns(:searches)[:software_infos][:results], @softwares.first.community
    assert_not_includes assigns(:searches)[:software_infos][:results], @softwares.last.community
  end

  should "software_infos search by relevance" do
    @softwares << create_software_info("Software Three", :acronym => "SFW", :finality => "Java")
    @softwares.last.license_info = LicenseInfo.create :version => "GPL - 3.0"


    @softwares.first.software_languages << create_software_language("Java", "8.0")
    @softwares.first.save!

    @softwares[1].community.name = "Java"
    @softwares[1].community.save!

    get(
      :software_infos,
      :sort => "relevance",
      :query => "Java"
    )

    assert_equal assigns(:searches)[:software_infos][:results][0], @softwares[1].community
    assert_equal assigns(:searches)[:software_infos][:results][1], @softwares[2].community
    assert_equal assigns(:searches)[:software_infos][:results][2], @softwares[0].community
  end

  should "software_infos search only public_software" do
    software_one = create_software_info("Software One", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Java", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software Three", :acronym => "SFW", :finality => "Java")
    software_three.public_software = false
    software_three.save!

    get(
      :software_infos,
      :software_type => "public_software"
    )

    assert_includes assigns(:searches)[:software_infos][:results], software_one.community
    assert_includes assigns(:searches)[:software_infos][:results], software_two.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_three.community
  end

  should "software_infos search public_software and other all" do
    software_one = create_software_info("Software One", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Java", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software Three", :acronym => "SFW", :finality => "Java")
    software_three.public_software = false
    software_three.save!

    get(
      :software_infos,
      :software_type => "all"
    )

    assert_includes assigns(:searches)[:software_infos][:results], software_one.community
    assert_includes assigns(:searches)[:software_infos][:results], software_two.community
    assert_includes assigns(:searches)[:software_infos][:results], software_three.community
  end

  should "software_infos search return only the software in params" do
    software_one = create_software_info("Software One", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Java", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software Three", :acronym => "SFW", :finality => "Java")

    get(
      :software_infos,
      :only_softwares => ["software-three", "java"]
    )

    assert_includes assigns(:searches)[:software_infos][:results], software_two.community
    assert_includes assigns(:searches)[:software_infos][:results], software_three.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_one.community
  end

  should "software_infos search return only the software in params order by Z-A" do
    software_one = create_software_info("Software One", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Java", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software Three", :acronym => "SFW", :finality => "Java")

    get(
      :software_infos,
      :only_softwares => ["software-three", "java"],
      :sort => "desc"
    )

    assert_equal assigns(:searches)[:software_infos][:results][0], software_three.community
    assert_equal assigns(:searches)[:software_infos][:results][1], software_two.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_one.community
  end


  should "software_infos search return only enabled softwares" do
    s1 = SoftwareInfo.first
    s2 = SoftwareInfo.last

    # First get them all normally
    get(
      :software_infos,
      :query => "software"
    )

    assert_includes assigns(:searches)[:software_infos][:results], s1.community
    assert_includes assigns(:searches)[:software_infos][:results], s2.community

    s2.community.disable

    # Now it should not contain the disabled community
    get(
      :software_infos,
      :query => "software"
    )

    assert_includes assigns(:searches)[:software_infos][:results], s1.community
    assert_not_includes assigns(:searches)[:software_infos][:results], s2.community
  end

  should "software_infos search not return software with secret community" do
    software_one = create_software_info("Software ABC", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Python", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software DEF", :acronym => "SFW", :finality => "Java")

    software_one.community.secret = true
    software_one.community.save!

    get(
      :software_infos,
    )

    assert_includes assigns(:searches)[:software_infos][:results], software_two.community
    assert_includes assigns(:searches)[:software_infos][:results], software_three.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_one.community
  end

  should "software_infos search not return sisp softwares" do
    software_one = create_software_info("Software ABC", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Python", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software DEF", :acronym => "SFW", :finality => "Java")

    software_one.sisp = true
    software_one.save!

    get(
      :software_infos,
    )

    assert_includes assigns(:searches)[:software_infos][:results], software_two.community
    assert_includes assigns(:searches)[:software_infos][:results], software_three.community
    assert_not_includes assigns(:searches)[:software_infos][:results], software_one.community
  end

  should "sisp search not return software without sisp" do
    software_one = create_software_info("Software ABC", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Python", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software DEF", :acronym => "SFW", :finality => "Java")

    software_two.sisp = true
    software_two.save!

    software_three.sisp = true
    software_three.save!

    get(
      :sisp,
    )

    assert_includes assigns(:searches)[:sisp][:results], software_two.community
    assert_includes assigns(:searches)[:sisp][:results], software_three.community
    assert_not_includes assigns(:searches)[:sisp][:results], software_one.community
  end

  should "sisp search by category" do
    software_one = create_software_info("Software ABC", :acronym => "SFO", :finality => "Help")
    software_two = create_software_info("Python", :acronym => "SFT", :finality => "Task")
    software_three = create_software_info("Software DEF", :acronym => "SFW", :finality => "Java")

    software_two.sisp = true
    software_two.community.categories << Category.last
    software_two.save!

    software_three.sisp = true
    software_three.save!

    get(
      :sisp,
      :selected_categories_id => [Category.last.id]
    )

    assert_includes assigns(:searches)[:sisp][:results], software_two.community
    assert_not_includes assigns(:searches)[:sisp][:results], software_three.community
    assert_not_includes assigns(:searches)[:sisp][:results], software_one.community
  end

  private

  def create_software_categories
    category_software = Category.create!(
      :name => "Software",
      :environment => @environment
    )
    Category.create(
      :name => "Category One",
      :environment => @environment,
      :parent => category_software
    )
    Category.create(
      :name => "Category Two",
      :environment => @environment,
      :parent => category_software
    )
  end

  def create_software_language(name, version)
    unless ProgrammingLanguage.find_by_name(name)
      ProgrammingLanguage.create(:name => name)
    end

    software_language = SoftwareLanguage.new
    software_language.programming_language = ProgrammingLanguage.find_by_name(name)
    software_language.version = version
    software_language.save!

    software_language
  end

  def create_software_database(name, version)
    unless DatabaseDescription.find_by_name(name)
      DatabaseDescription.create(:name => name)
    end

    software_database = SoftwareDatabase.new
    software_database.database_description = DatabaseDescription.find_by_name(name)
    software_database.version = version
    software_database.save!

    software_database
  end

end
