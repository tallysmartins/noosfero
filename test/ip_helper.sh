# make IP addresses avaliable at the environment so we can refer to hosts by
# name, e.g.
#
#   curl http://$reverseproxy
#   nmap -p 5423 $database
#
# Each node in the `peers:` entry in nodes.yaml will have its own variable
#
eval $(ruby -ryaml -e 'YAML.load_file("nodes.yaml").first[1]["peers"].each { |k,v| puts "#{k}=#{v}" }')

