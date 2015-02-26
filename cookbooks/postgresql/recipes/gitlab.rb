execute 'createuser:gitlab' do
  command 'createuser gitlab'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'gitlab';"`.strip.to_i == 0
  end
end

execute 'createdb:gitlab' do
  command 'createdb --owner=gitlab gitlab'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'gitlab';"`.strip.to_i == 0
  end
end

