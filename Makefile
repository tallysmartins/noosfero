OBSPROJECT = isv:spb:devel

#############################################################################

packages = $(shell basename -s .spec */*.spec)
obsdir = .obs

-include .config.mk

all:
	@echo "Usage:"
	@echo
	@echo '$$ make $${pkg}-checkout   checkout $${pkg}'
	@echo '$$ make $${pkg}-upload     uploads package $${pkg}'
	@echo '$$ make $${pkg}-build      builds package $${pkg} locally'
	@echo '$$ make $${pkg}-diff       diff from OBS to git for package $${pkg}'
	@echo
	@echo '$${pkg} can be one of: $(packages)'
	@echo
	@echo Use OBSPROJECT=project:name to control where to upload to.
	@echo '(currently: $(OBSPROJECT))'. Example:
	@echo
	@echo \ \ \ \ $$ make colab-upload OBSPROJECT=isv:spb:v3
	@echo
	@echo 'Operations on all packages:'
	@echo
	@echo '$$ make diff               diff of all packages from OBS to git'
	@echo '$$ make status|st          diffstat of all packages from OBS to git'
	@echo '$$ make checkout-all       checks out all packages from OBS'
	@echo '$$ make build-all          builds all packages locally'


checkout_packages = $(patsubst %, %-checkout, $(packages))
build_packages = $(patsubst %, %-build, $(packages))
upload_packages = $(patsubst %, %-upload, $(packages))
diff_packages = $(patsubst %, %-diff, $(packages))

.PHONY: $(checkout_packages) $(build_packages) $(upload_packages) $(diff_packages)

checkout-all: $(checkout_packages)
build-all: $(build_packages)

$(checkout_packages): %-checkout : %
	mkdir -p $(obsdir)
	[ -d $(obsdir)/$(OBSPROJECT)/$* ] && \
		(cd $(obsdir)/$(OBSPROJECT)/$* && osc update) || \
		(cd $(obsdir) && osc checkout $(OBSPROJECT) $*)

$(build_packages): %-build : %
	mkdir -p ~/rpmbuild/SOURCES
	cp $(obsdir)/$(OBSPROJECT)/$*/*.tar.* ~/rpmbuild/SOURCES/
	cp $*/*.patch ~/rpmbuild/SOURCES/ || true
	cd $* && $(BUILD_PREFIX) rpmbuild -bb $*.spec

$(upload_packages): %-upload : %-checkout
	$(MAKE) $*-diff
	@printf "Confirm upload? [y/N] "; read confirm; test "$$confirm" = y -o "$$confirm" = Y
	cp $*/* $(obsdir)/$(OBSPROJECT)/$*
	(cd $(obsdir)/$(OBSPROJECT)/$*; osc add *; osc commit -m "update $*")

$(diff_packages): %-diff : %
	@git diff --no-index $(obsdir)/$(OBSPROJECT)/$*/$*.spec $*/$*.spec || true

diff: $(diff_packages)

status st:
	@$(MAKE) diff | diffstat -C
