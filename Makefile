packages = $(shell basename --suffix=.spec specs/*/*.spec)

all:
	@echo "Usage:"
	@echo
	@for pkg in $(packages); do printf 'make %-20s # uploads %s.spec to obs\n' $$pkg $$pkg; done

$(packages):
	@spec=$$(find specs/ -name $@.spec); \
		project=isv:spb:$$(basename $$(dirname $$spec)); \
		$(MAKE) upload package=$@ spec=$$spec project=$$project

upload:
	mkdir -p obs
	if test -d obs/$(project)/$(package); then (cd obs/$(project)/$(package) && osc update); else (cd obs && osc checkout $(project) $(package)); fi
	cp $(spec) obs/$(project)/$(package)/
	cd obs/$(project)/$(package) && osc commit -m 'Update $(package)'
