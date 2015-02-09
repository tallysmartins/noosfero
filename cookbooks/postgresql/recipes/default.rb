package 'postgresql-server'

execute 'postgresql-setup initdb || true' do
  notifies :start, 'service[postgresql]'
end

service 'postgresql' do
  action :start
end
