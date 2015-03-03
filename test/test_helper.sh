export PATH="$(dirname $0)/bin:$PATH"
export ROOTDIR="$(dirname $0)/.."

run_on() {
  local vm="$1"
  shift
  echo 'export PATH=/vagrant/test/bin:$PATH;' "$@" | ssh -F .ssh_config "$vm"
}

load_shunit2() {
  if [ `which shunit2 > /dev/null 2>&1` ]; then
    . shunit2
  elif [ -e /usr/share/shunit2/shunit2 ]; then
    . /usr/share/shunit2/shunit2
  else
    echo "Could not find shunit2, please, make sure you have it installed."
  fi
}

. $(dirname $0)/ip_helper.sh

