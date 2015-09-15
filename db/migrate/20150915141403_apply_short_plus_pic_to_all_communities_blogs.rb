class ApplyShortPlusPicToAllCommunitiesBlogs < ActiveRecord::Migration
  def up
    Community.all.each do |community|
      set_short_plus_pic_to_blog community.blog
    end

    puts ""
  end

  def down
    say "This can't be reverted"
  end

  private

  def set_short_plus_pic_to_blog blog
    if blog
      blog.visualization_format = "short+pic"
      blog.save!
      print "."
    end
  end
end
