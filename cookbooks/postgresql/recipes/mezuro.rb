# Kalibro Processor
execute 'createuser:kalibro_processor' do
  command 'createuser kalibro_processor'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'kalibro_processor';"`.strip.to_i == 0
  end
end

execute 'createdb:kalibro_processor' do
  command 'createdb --owner=kalibro_processor kalibro_processor'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'kalibro_processor';"`.strip.to_i == 0
  end
end

# Kalibro Configurations
execute 'createuser:kalibro_configurations' do
  command 'createuser kalibro_configurations'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'kalibro_configurations';"`.strip.to_i == 0
  end
end

execute 'createdb:kalibro_configurations' do
  command 'createdb --owner=kalibro_configurations kalibro_configurations'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'kalibro_configurations';"`.strip.to_i == 0
  end
end

# Prezento
execute 'createuser:prezento' do
  command 'createuser prezento'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(*) from pg_user where usename = 'prezento';"`.strip.to_i == 0
  end
end

execute 'createdb:prezento' do
  command 'createdb --owner=prezento prezento'
  user 'postgres'
  only_if do
    `sudo -u postgres -i psql --quiet --tuples-only -c "select count(1) from pg_database where datname = 'prezento';"`.strip.to_i == 0
  end
end
