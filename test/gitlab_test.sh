. $(dirname $0)/test_helper.sh

test_database_connectivity() {
  assertTrue 'gitlab database connectivity' 'run_on integration psql -h database -U gitlab < /dev/null'
}

test_gitlab_running() {
  assertTrue 'gitlab running' 'run_on integration pgrep -fa unicorn.*gitlab'
}

test_gitlab_responds() {
  assertTrue 'gitlab responds on HTTP' 'run_on integration curl http://localhost:8080/gitlab/public/projects'
}

. shunit2
