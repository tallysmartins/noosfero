require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/../helpers/plugin_test_helper'

class SoftwareEventsBlockTest < ActiveSupport::TestCase
  include PluginTestHelper

  def setup
    @community = create_community("A new community")
    @software_events_block = SoftwareEventsBlock.new

    box = Box.new
    box.owner = @community
    box.blocks << @software_events_block
    box.save!
  end

  should "give community events that have not yet finished ordered by start date" do
    assert_equal true, @software_events_block.community_events.empty?

    e1 = Event.new :name=>"Event 1", :body=>"Event 1 body",
                   :start_date=>DateTime.now, :end_date=>(DateTime.now + 1.month)

    e2 = Event.new :name=>"Event 2", :body=>"Event 2 body",
                  :start_date=>(DateTime.now - 10.days), :end_date=>(DateTime.now + 10.days)

    e3 = Event.new :name=>"Event 3", :body=>"Event 3 body",
                  :start_date=>(DateTime.now - 20.days), :end_date=>(DateTime.now - 10.days)

    @community.events << e1
    @community.events << e2
    @community.events << e3
    @community.save!

    assert_equal false, @software_events_block.community_events.include?(e3)
    assert_equal e2, @software_events_block.community_events.first
    assert_equal e1, @software_events_block.community_events.last
  end
end
