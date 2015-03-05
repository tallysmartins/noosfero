export PATH="$(dirname $0)/bin:$PATH"
export ROOTDIR="$(dirname $0)/.."

run_on() {
  local vm="$1"
  shift
  echo 'export PATH=/vagrant/test/bin:$PATH;' "$@" | ssh -F .ssh_config "$vm"
}

load_shunit2() {
  if [ -e /usr/share/shunit2/shunit2 ]; then
    . /usr/share/shunit2/shunit2
  else
    . shunit2
  fi
}

. $(dirname $0)/ip_helper.sh

