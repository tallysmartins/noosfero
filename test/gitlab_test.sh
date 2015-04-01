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
  assertTrue 'gitlab static content served by nginx' "run_on integration curl --head http://localhost:81/gitlab/assets/$file | grep 'Content-Type: text/css'"
}

test_redirects_to_the_correct_host() {
  redirect=$(curl-host softwarepublico.dev --head https://softwarepublico.dev/gitlab/dashboard/projects | grep-header Location)
  assertEquals "Location: https://softwarepublico.dev/gitlab/users/sign_in" "$redirect"
}

load_shunit2
