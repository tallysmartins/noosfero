OBSPROJECT = isv:spb:v4

#############################################################################

packages = $(shell basename -s .spec */*.spec)
obsdir = .obs

-include .config.mk

all:
	@echo "Usage:"
	@echo
	@for pkg in $(packages); do printf 'make %-20s # uploads %s.spec to obs\n' $$pkg $$pkg; done

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
	cp $(obsdir)/$(OBSPROJECT)/$*/*.tar.* ~/rpmbuild/SOURCES/
	cp $*/*.patch ~/rpmbuild/SOURCES/ || true
	cd $* && $(BUILD_PREFIX) rpmbuild -bb $*.spec

$(upload_packages): %-upload : % checkout-%
	(cd $(obsdir)/$(OBSPROJECT)/$* && osc remove *)
	cp $*/* $(obsdir)/$(OBSPROJECT)/$*
	(cd $(obsdir)/$(OBSPROJECT)/$* && osc add * && osc commit -m "update $*")

$(diff_packages): %-diff : %
	git diff --no-index $(obsdir)/$(OBSPROJECT)/$*/$*.spec $*/$*.spec || true

diff: $(diff_packages)

status st:
	@$(MAKE) diff | diffstat -C
