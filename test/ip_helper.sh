# make IP addresses avaliable at the environment so we can refer to hosts by
# name, e.g.
#
#   curl http://$reverseproxy
#   nmap -p 5423 $database
#
# Each entry in config/${SPB_ENV}/ips.yaml will have its own variable
#

eval $(sed -E '/[0-9]{1,3}\./!d; s/^ *//; s/: */=/' ${ROOTDIR:-.}/config/${SPB_ENV:-local}/ips.yaml)
