require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareEventsBlockTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @community = create_community("A new community")
    @software_events_block = SoftwareEventsBlock.new

    box = Box.new
    box.position = 1
    box.owner = @community
    box.blocks << @software_events_block
    box.save!

    @e1 = Event.new :name=>"Event 1", :body=>"Event 1 body",
                   :start_date=>DateTime.now, :end_date=>(DateTime.now + 1.month)

    @e2 = Event.new :name=>"Event 2", :body=>"Event 2 body",
                  :start_date=>(DateTime.now - 10.days), :end_date=>(DateTime.now + 10.days)

    @e3 = Event.new :name=>"Event 3", :body=>"Event 3 body",
                  :start_date=>(DateTime.now - 20.days), :end_date=>(DateTime.now - 10.days)

    @community.events << @e1
    @community.events << @e2
    @community.events << @e3
    @community.save!
  end

  should "give community events that have not yet finished ordered by start date" do
    events = @software_events_block.get_events

    assert_equal false, events.include?(@e3)
    assert_equal @e2, events.first
    assert_equal @e1, events.last
  end

  should "give community events except by a event with a given slug" do
    events = @software_events_block.get_events_except(@e1.slug)

    assert_equal false, events.include?(@e1)
  end

  should "tell if there are events to be displayed" do
    assert_equal true, @software_events_block.has_events_to_display?

    @community.events.update_all :start_date => (DateTime.now - 2.days),
                                 :end_date => (DateTime.now - 1.day)

    assert_equal false, @software_events_block.has_events_to_display?
  end

  should "tell that the block must show the title in other areas that are no the main area" do
    assert_equal false, @software_events_block.should_display_title?

    @software_events_block.box.position = 3
    @software_events_block.save!

    assert_equal true, @software_events_block.should_display_title?
  end
end
