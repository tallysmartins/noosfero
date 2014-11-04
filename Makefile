PROJECT = softwarepublico
VERSION = 2014.07
COMPONENTS = solr
ARCH = $(shell uname -i)

TARBALL_FORMAT = tar.gz
TARBALLS = $(patsubst %,build/$(PROJECT)-%-$(VERSION).$(TARBALL_FORMAT),$(COMPONENTS))
RPMS = $(patsubst %.$(TARBALL_FORMAT),%-1.$(ARCH).rpm, $(TARBALLS))
GENERATED += $(TARBALLS) $(RPMS)


ifeq ("$(V)", "1")
	Q :=
	RPMBUILD_FLAGS :=
	qecho := @true
else
	Q := @
	RPMBUILD_FLAGS := --quiet --short-circuit
	qecho := @echo
endif

.PHONY: $(COMPONENTS)

all: rpm

sdist: $(TARBALLS)

rpm: $(RPMS)

$(TARBALLS): build/$(PROJECT)-%-$(VERSION).$(TARBALL_FORMAT): %
	$(qecho) "TAR\t$@"
	$(Q)cp -r $< $(PROJECT)-$<-$(VERSION)
	$(Q)mkdir -p build
	$(Q)tar vczf $@ $(PROJECT)-$<-$(VERSION)
	$(Q)rm -rf $(PROJECT)-$<-$(VERSION)

$(RPMS): build/$(PROJECT)-%-$(VERSION)-1.$(ARCH).rpm: build/$(PROJECT)-%-$(VERSION).$(TARBALL_FORMAT)

$(RPMS): build/$(PROJECT)-%-$(VERSION)-1.$(ARCH).rpm: rpm/%.spec
	$(qecho) "RPM\t$@"
	$(Q)mkdir -p ~/rpmbuild/SOURCES
	$(Q)component=$$(basename $< .spec) && \
		ln -f build/$(PROJECT)-$$component-$(VERSION).$(TARBALL_FORMAT) ~/rpmbuild/SOURCES/ && \
		rpmbuild -ba $(RPMBUILD_FLAGS) $< && \
		ln -f ~/rpmbuild/RPMS/$(ARCH)/$(PROJECT)-$$component-$(VERSION)-1.el6.$(ARCH).rpm $@

%.spec: %.spec.in
	$(qecho) "SPEC\t$@"
	$(Q)(sed -e 's/@@version@@/$(VERSION)/g' $^ > $@) || ($(RM) $@; false)
GENERATED += $(patsubst %.in,%,$(wildcard rpm/*.spec.in))

clean:
	$(qecho) Cleaning
	$(Q)$(RM) $(GENERATED)
