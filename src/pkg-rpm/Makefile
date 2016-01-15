OBSPROJECT = isv:spb:devel
COPR_PROJECT = softwarepublico/v5
LOCAL_BUILD_DIR = $(CURDIR)/build

# Vagrant environment does not accept links from/to shared folder
ifeq "/vagrant" "$(shell ls -1d /vagrant 2>/dev/null)"
LOCAL_BUILD_DIR = /home/vagrant/rpmbuild
endif

#############################################################################

packages = $(shell basename -s .spec */*.spec)
obsdir = .obs

-include .config.mk

all:
	@echo "Usage:"
	@echo
	@echo '$$ make $${pkg}-build      builds package $${pkg} locally'
	@echo '$$ make $${pkg}-build-src  builds SRPM package $${pkg} locally'
	@echo '$$ make $${pkg}-upload     uploads package $${pkg} to Copr'
	@echo
	@echo '$${pkg} can be one of: $(packages)'
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

# Local
build_packages = $(patsubst %, %-build, $(packages))
build_src_packages = $(patsubst %, %-build-src, $(packages))

# Copr
upload_packages = $(patsubst %, %-upload, $(packages))

# OBS
checkout_packages_obs = $(patsubst %, %-checkout-obs, $(packages))
upload_packages_obs = $(patsubst %, %-upload-obs, $(packages))
diff_packages_obs = $(patsubst %, %-diff-obs, $(packages))

.PHONY: $(build_packages) $(checkout_packages_obs) $(upload_packages_obs) $(diff_packages_obs) copr-cli

### Targets

build-all: $(build_packages)

$(build_packages): %-build : %
	mkdir -p $(LOCAL_BUILD_DIR)/SOURCES
	cp $*/*.tar.* $(LOCAL_BUILD_DIR)/SOURCES/
	cp $*/*.patch $(LOCAL_BUILD_DIR)/SOURCES/ || true
	cd $* && $(BUILD_PREFIX) rpmbuild --define "_topdir $(LOCAL_BUILD_DIR)" -bb $*.spec

$(build_src_packages): %-build-src : %
	mkdir -p $(LOCAL_BUILD_DIR)/SOURCES
	cp $*/*.tar.* $(LOCAL_BUILD_DIR)/SOURCES/
	cp $*/*.patch $(LOCAL_BUILD_DIR)/SOURCES/ || true
	rm -f $(LOCAL_BUILD_DIR)/SRPMS/$*-*.src.rpm
	cd $* && $(BUILD_PREFIX) rpmbuild --define "_topdir $(LOCAL_BUILD_DIR)" -bs $*.spec --nodeps

$(upload_packages): %-upload : %-build-src % copr-cli
	.virtualenv/bin/copr-cli build $(COPR_PROJECT) $(LOCAL_BUILD_DIR)/SRPMS/$*-*.src.rpm --nowait

copr-cli: .virtualenv/bin/copr-cli

.virtualenv/bin/copr-cli:
	virtualenv .virtualenv
	.virtualenv/bin/pip install copr-cli

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

clean:
	rm -rf */*.tar.*
	rm -rf build/
	rm -rf .virtualenv/
