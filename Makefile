all:
	@echo "Usage:"
	@echo
	@echo 'make gitlab       # uploads gitlab.spec to obs'
	@echo 'make gitlab-shell # uploads gitlab-shell.spec to obs'

gitlab gitlab-shell:
	$(MAKE) upload PACKAGE=$@

obs_project = isv:spb:gitlab

upload:
	test -n "$(PACKAGE)"
	mkdir -p obs
	if test -d obs/$(obs_project)/$(PACKAGE); then (cd obs/$(obs_project)/$(PACKAGE) && osc update); else (cd obs && osc checkout $(obs_project) $(PACKAGE)); fi
	cp $(PACKAGE).spec obs/isv:spb:gitlab/$(PACKAGE)/
	cd obs/isv:spb:gitlab/$(PACKAGE) && osc commit -m 'Update $(PACKAGE)'
