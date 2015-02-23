export PATH="$(dirname $0)/bin:$PATH"
export ROOTDIR="$(readlink -f $(dirname $0)/..)"

run_on() {
  local vm="$1"
  shift
  ssh -F .ssh_config "$vm" -- 'export PATH=/vagrant/test/bin:$PATH;' "$@"
}

. $(dirname $0)/ip_helper.sh
