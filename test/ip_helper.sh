# make IP addresses avaliable at the environment so we can refer to hosts by
# name, e.g.
#
#   curl http://$reverseproxy
#   nmap -p 5423 $database
#
# Each node in the `peers:` entry in nodes.yaml will have its own variable
#

eval $(sed -e '/\S*:\s*[0-9]\+\./!d; s/^\s*//; s/:\s*/=/' ${ROOTDIR:-/vagrant}/nodes.yaml)

