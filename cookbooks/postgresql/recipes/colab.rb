execute 'createuser:colab' do
  command 'createuser colab'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'colab';"`.strip.to_i == 0
  end
end

execute 'createdb:colab' do
  command 'createdb --owner=colab colab'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'colab';"`.strip.to_i == 0
  end
end

