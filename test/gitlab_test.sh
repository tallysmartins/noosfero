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

test_static_content_served_correctly() {
  file=$(run_on integration ls -1 '/usr/lib/gitlab/public/assets/*.css' | head -1 | xargs basename)
  assertTrue 'gitlab static content served by nginx' "run_on integration curl --head http://localhost:8081/gitlab/assets/$file | grep 'Content-Type: text/css'"
}

. shunit2
