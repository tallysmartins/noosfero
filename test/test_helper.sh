export PATH="$(dirname $0)/bin:$PATH"

run_on() {
  local vm="$1"
  shift
  ssh -F .ssh_config "$vm" -- 'export PATH=/vagrant/test/bin:$PATH;' "$@"
}

. $(dirname $0)/ip_helper.sh
