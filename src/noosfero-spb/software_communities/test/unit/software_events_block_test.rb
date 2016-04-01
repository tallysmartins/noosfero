require 'test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareEventsBlockTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @community = create_community("A new community")
    @software_events_block = SoftwareCommunitiesPlugin::SoftwareEventsBlock.new

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

    @e4 = Event.new :name=>"Event 4", :body=>"Event 4 body",
    :start_date=>(DateTime.now), :end_date=>(DateTime.now)

    @e5 = Event.new :name=>"Event 5", :body=>"Event 5 body",
    :start_date=>(DateTime.now + 5.days)

    @e6 = Event.new :name=>"Event 6", :body=>"Event 5 body",
    :start_date=>(DateTime.now)

    @community.events << @e1
    @community.events << @e2
    @community.events << @e3
    @community.events << @e4
    @community.events << @e5
    @community.events << @e6
    @community.save!
  end

  should "get events with start date equals or bigger than current day ordered by start date" do
    @software_events_block.amount_of_events = 6
    @software_events_block.save
    events = @software_events_block.get_events

    assert_equal false, events.include?(@e2)
    assert_equal false, events.include?(@e3)

    assert_equal true, events.include?(@e1)
    assert_equal true, events.include?(@e4)
    assert_equal true, events.include?(@e5)
    assert_equal true, events.include?(@e6)

    assert_equal @e1, events.first
    assert_equal @e5, events.last
  end

  should "include community events that have no end date" do
    @software_events_block.amount_of_events = 6
    @software_events_block.save
    events = @software_events_block.get_events

    assert_equal true, events.include?(@e5)
    assert_equal true, events.include?(@e6)
  end

  should "give community events except by a event with a given slug" do
    events = @software_events_block.get_events_except(@e1.slug)

    assert_equal false, events.include?(@e1)
  end

  should "tell if there are events to be displayed" do
    assert_equal true, @software_events_block.has_events_to_display?

    update_all_events (DateTime.now - 2.days), (DateTime.now - 1.day)

    assert_equal false, @software_events_block.has_events_to_display?
  end

  should "tell if there are events to be displayed when given a event page slug" do
    update_all_events (DateTime.now - 2.days), (DateTime.now - 1.day)

    assert_equal false, @software_events_block.has_events_to_display?

    last_event = @community.events.last
    last_event.start_date = DateTime.now
    last_event.end_date = DateTime.now + 1.day
    last_event.save!

    assert_equal true, @software_events_block.has_events_to_display?
    assert_equal false, @software_events_block.has_events_to_display?(last_event.slug)
  end

  should "tell that the block must show the title in other areas that are no the main area" do
    assert_equal false, @software_events_block.should_display_title?

    @software_events_block.box.position = 3
    @software_events_block.save!

    assert_equal true, @software_events_block.should_display_title?
  end

  private

    def update_all_events start_date, end_date
      @community.events.update_all :start_date => start_date, :end_date => end_date
    end
end
