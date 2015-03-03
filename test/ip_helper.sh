# make IP addresses avaliable at the environment so we can refer to hosts by
# name, e.g.
#
#   curl http://$reverseproxy
#   nmap -p 5423 $database
#
# Each entry in ips.${SPB_ENV}.yaml will have its own variable
#

eval $(sed -E '/[0-9]{1,3}\./!d; s/^ *//; s/: */=/' ${ROOTDIR:-.}/ips.${SPB_ENV:-development}.yaml)
