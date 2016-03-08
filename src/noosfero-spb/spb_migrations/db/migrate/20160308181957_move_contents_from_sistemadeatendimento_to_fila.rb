class MoveContentsFromSistemadeatendimentoToFila < ActiveRecord::Migration
  def change
    environment = Environment.default
    sistemadeatendimento = environment.communities.where(:identifier => 'sistemadeatendimento').first
    fila = environment.communities.where(:identifier => 'fila').first

    # Migrate foruns

    source = sistemadeatendimento.folders.where(:slug => 'historico-de-foruns').first
    target = fila.folders.where(:slug => 'historico-de-foruns').first
    children = source.all_children

    execute("UPDATE articles SET parent_id = #{target.id} WHERE parent_id = #{source.id}")
    execute("UPDATE articles SET profile_id = #{fila.id} WHERE id in (#{children.map(&:id).join(',')})")

    # Migrate blog posts

    source = sistemadeatendimento.folders.where(:slug => 'blog').first
    target = fila.folders.where(:slug => 'blog').first
    children = source.all_children

    execute("UPDATE articles SET parent_id = #{target.id} WHERE parent_id = #{source.id}")
    execute("UPDATE articles SET profile_id = #{fila.id} WHERE id in (#{children.map(&:id).join(',')})")
  end
end
