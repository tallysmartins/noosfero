package 'postgresql-server'

execute 'postgresql-setup initdb || true'

template '/var/lib/pgsql/data/pg_hba.conf' do
  user 'postgres'
  group 'postgres'
  mode 0600
  notifies :restart, 'service[postgresql]'
end

template '/var/lib/pgsql/data/postgresql.conf' do
  user 'postgres'
  group 'postgres'
  mode 0600
  notifies :restart, 'service[postgresql]'
end

service 'postgresql' do
  action :start
  supports :restart => true
end
