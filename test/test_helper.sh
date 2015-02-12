run_on() {
  local vm="$1"
  shift
  vagrant ssh "$vm" -- "$@"
}

curl=/vagrant/test/bin/curl
