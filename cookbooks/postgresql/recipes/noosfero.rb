execute 'createuser:noosfero' do
  command 'createuser noosfero'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'noosfero';"`.strip.to_i == 0
  end
end

execute 'createdb:noosfero' do
  command 'createdb --owner=noosfero noosfero'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'noosfero';"`.strip.to_i == 0
  end
end

execute 'grant:noosfero:colab' do
  command 'psql -c "GRANT SELECT ON users TO colab" noosfero'
  user 'postgres'
end
