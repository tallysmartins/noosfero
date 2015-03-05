. $(dirname $0)/test_helper.sh

test_postgresql_running() {
  assertTrue 'PostgreSQL running' 'run_on database pgrep -fa postgres'
}

test_colab_database_created() {
  assertTrue 'colab database created in PostgreSQL' 'run_on database sudo -u postgres -i psql colab < /dev/null'
}

test_gitlab_database_created() {
  assertTrue 'gitlab database created in PostgreSQL' 'run_on database sudo -u postgres -i psql gitlab < /dev/null'
}

test_noosfero_database_created() {
  assertTrue 'noosfero database created in PostgreSQL' 'run_on database sudo -u postgres -i psql noosfero < /dev/null'
}

load_shunit2

