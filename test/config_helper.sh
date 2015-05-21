# exports all configuration variables into the environment with a config_
# prefix, e.g.
#
# external_hostname → $config_external_hostname

eval $(sed -e '/^\S*:\s*\S\+/!d; s/^/config_/; s/:\s*/=/' ${ROOTDIR:-.}/config/${SPB_ENV:-local}/config.yaml)
