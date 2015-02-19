export PATH="$(dirname $0)/bin:$PATH"

run_on() {
  local vm="$1"
  shift
  vagrant ssh "$vm" -- "$@"
}

# waits until a file exists
wait_for() {
  local machine="$1"
  local file="$2"
  local total=0
  while [ "$total" -lt 10 ]; do
    if run_on "$machine" sudo test -f "$file"; then
      return 0
    fi
    sleep 1
    total=$(($total + 1))
  done
  return 1
}

. $(dirname $0)/ip_helper.sh
