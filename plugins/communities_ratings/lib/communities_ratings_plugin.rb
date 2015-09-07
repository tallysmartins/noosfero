class CommunitiesRatingsPlugin < Noosfero::Plugin
  include Noosfero::Plugin::HotSpot

  def self.plugin_name
    "Communities Ratings"
  end

  def self.plugin_description
    _("A plugin that allows you to rate a community and comment about it.")
  end

  module Hotspots
    def communities_ratings_plugin_comments_extra_fields
      nil
    end

    def communities_ratings_title
      nil
    end

    def communities_ratings_plugin_star_message
      nil
    end

    def communities_ratings_plugin_extra_fields_show_data user_rating
      nil
    end
  end

  # Plugin Hotspot to display the average rating
  def display_community_average_rating community
    unless community.nil?
      average_rating = CommunityRating.average_rating community.id

      Proc::new {
        render :file => 'blocks/display_community_average_rating',
               :locals => {
                 :profile_identifier => community.identifier,
                 :average_rating => average_rating
               }
      }
    end
  end

  def self.extra_blocks
    {
      CommunitiesRatingsBlock => {:type => [Community], :position => ['1']},
      AverageRatingBlock => {:type => [Community]}
    }
  end

  def stylesheet?
    true
  end

  def js_files
    %w(
      public/rate.js
      public/comunities_rating_management.js
    )
  end

end
