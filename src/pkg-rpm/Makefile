OBSPROJECT = isv:spb:devel

#############################################################################

packages = $(shell basename -s .spec */*.spec)
obsdir = .obs

-include .config.mk

all:
	@echo "Usage:"
	@echo
	@echo
	@echo '$${pkg} can be one of: $(packages)'
	@echo
	@echo '$$ make $${pkg}-build      builds package $${pkg} locally'
	@echo
	@echo 'Operations on all packages:'
	@echo
	@echo '$$ make build-all          builds all packages locally'
	@echo
	@echo
	@echo 'Working with OBS (deprecated):' 
	@echo
	@echo '$$ make $${pkg}-checkout-obs   checkout $${pkg}'
	@echo '$$ make $${pkg}-upload-obs     uploads package $${pkg}'
	@echo '$$ make $${pkg}-diff-obs       diff from OBS to git for package $${pkg}'
	@echo
	@echo Use OBSPROJECT=project:name to control where to upload to.
	@echo '(currently: $(OBSPROJECT))'. Example:
	@echo
	@echo \ \ \ \ $$ make colab-upload-obs OBSPROJECT=isv:spb:v3
	@echo
	@echo 'Operations on all packages:'
	@echo
	@echo '$$ make diff-obs               diff of all packages from OBS to git'
	@echo '$$ make status-obs|st-obs      diffstat of all packages from OBS to git'
	@echo '$$ make checkout-all-obs       checks out all packages from OBS'


build_packages = $(patsubst %, %-build, $(packages))
checkout_packages_obs = $(patsubst %, %-checkout-obs, $(packages))
upload_packages_obs = $(patsubst %, %-upload-obs, $(packages))
diff_packages_obs = $(patsubst %, %-diff-obs, $(packages))

.PHONY: $(build_packages) $(checkout_packages_obs) $(upload_packages_obs) $(diff_packages_obs)

build-all: $(build_packages)

$(build_packages): %-build : %
	mkdir -p ~/rpmbuild/SOURCES
	cp $(obsdir)/$(OBSPROJECT)/$*/*.tar.* ~/rpmbuild/SOURCES/
	cp $*/*.patch ~/rpmbuild/SOURCES/ || true
	cd $* && $(BUILD_PREFIX) rpmbuild -bb $*.spec


### OBS targets (deprecated)

checkout-all-obs: $(checkout_packages_obs)

$(checkout_packages_obs): %-checkout-obs : %
	mkdir -p $(obsdir)
	[ -d $(obsdir)/$(OBSPROJECT)/$* ] && \
		(cd $(obsdir)/$(OBSPROJECT)/$* && osc update) || \
		(cd $(obsdir) && osc checkout $(OBSPROJECT) $*)

$(upload_packages_obs): %-upload-obs : %-checkout-obs
	$(MAKE) $*-diff-obs
	@printf "Confirm upload? [y/N] "; read confirm; test "$$confirm" = y -o "$$confirm" = Y
	cp $*/* $(obsdir)/$(OBSPROJECT)/$*
	(cd $(obsdir)/$(OBSPROJECT)/$*; osc add *; osc commit -m "update $*")

$(diff_packages_obs): %-diff-obs : %
	@git diff --no-index $(obsdir)/$(OBSPROJECT)/$*/$*.spec $*/$*.spec || true

diff-obs: $(diff_packages_obs)

status-obs st-obs:
	@$(MAKE) diff | diffstat -C
