packages = $(shell basename --suffix=.spec specs/*/*.spec)
checkout_packages = $(patsubst %, checkout-%, $(packages))
build_packages = $(patsubst %, build-%, $(packages))

-include config.mk

all:
	@echo "Usage:"
	@echo
	@for pkg in $(packages); do printf 'make %-20s # uploads %s.spec to obs\n' $$pkg $$pkg; done

.PHONY: $(packages) $(checkout_packages) $(build_packages)

$(checkout_packages):
	mkdir -p obs
	package=$(patsubst checkout-%,%,$@); \
		spec=$$(find specs/ -name $$package.spec); \
		project=isv:spb:$$(basename $$(dirname $$spec)); \
		if test -d obs/$$project/$$package; then (cd obs/$$project/$$package && osc update); else (cd obs && osc checkout $$project $$package); fi

$(packages): % : checkout-%
	spec=$$(find specs/ -name $@.spec); \
		project=isv:spb:$$(basename $$(dirname $$spec)); \
		cp $$spec obs/$$project/$@ && \
		cd obs/$$project/$@ && osc commit -m 'Update $@'

$(build_packages): build-%: checkout-%
	mkdir -p ~/rpmbuild/SOURCES
	package=$*; \
		spec=$$(find specs/ -name $$package.spec); \
		project=isv:spb:$$(basename $$(dirname $$spec)); \
		cp obs/$$project/$$package/*.tar.* ~/rpmbuild/SOURCES && \
		$(BUILD_PREFIX) rpmbuild -bb $$spec
