class MoveSpbBlogToNoticias < ActiveRecord::Migration
  def change
    spb = Environment.default.communities.where(:identifier => 'spb').first
    blog = spb.blogs.where(:slug => 'blog').first
    noticias = spb.blogs.where(:slug => 'noticias').first

    execute("UPDATE articles SET parent_id = #{noticias.id} WHERE parent_id = #{blog.id} AND profile_id = #{spb.id}")
  end
end
