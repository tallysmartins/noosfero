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


curl=/vagrant/test/bin/curl

# make IP addresses avaliable at the environment so we can refer to hosts by
# name, e.g.
#
#   curl http://$reverseproxy
#   nmap -p 5423 $database
#
# Each node in the `peers:` entry in nodes.yaml will have its own variable
#
eval $(ruby -ryaml -e 'YAML.load_file("nodes.yaml").first[1]["peers"].each { |k,v| puts "#{k}=#{v}" }')
