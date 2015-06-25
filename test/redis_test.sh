. $(dirname $0)/test_helper.sh

test_redis_running() {
  assertTrue "redis running" 'run_on database pgrep -f redis'
}

test_redis_listens_on_local_network() {
  assertTrue 'redis listening on local network' 'run_on integration redis-cli -h database get foo'
}

load_shunit2
