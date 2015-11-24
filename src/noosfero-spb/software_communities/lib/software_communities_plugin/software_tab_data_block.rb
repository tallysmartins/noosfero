class SoftwareCommunitiesPlugin::SoftwareTabDataBlock < Block
  attr_accessible :show_name, :displayed_blog

  settings_items :show_name, :type => :boolean, :default => false
  settings_items :displayed_blog, :type => :integer, :default => 0

  TOTAL_POSTS_DYSPLAYED = 5

  def self.description
    _('Software Tab Data')
  end

  def help
    _('This block is used by colab to insert data into Noosfero')
  end

  def content(args={})
    block = self

    lambda do |object|
      render(
        :file => 'blocks/software_tab_data',
        :locals => {
          :block => block
        }
      )
    end
  end

  def blogs
    self.owner.blogs
  end

  def actual_blog
    # As :displayed_blog default value is 0, it falls to the first one
    blogs.find_by_id(self.displayed_blog) || blogs.first
  end

  def posts
    blog = actual_blog

    if blog and (not blog.posts.empty?)
      blog.posts.limit(TOTAL_POSTS_DYSPLAYED)
    else
      []
    end
  end
end
