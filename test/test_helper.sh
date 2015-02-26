export PATH="$(dirname $0)/bin:$PATH"
export ROOTDIR="$(readlink -f $(dirname $0)/..)"

run_on() {
  local vm="$1"
  shift
  echo 'export PATH=/vagrant/test/bin:$PATH;' "$@" | ssh -F .ssh_config "$vm"
}

. $(dirname $0)/ip_helper.sh
