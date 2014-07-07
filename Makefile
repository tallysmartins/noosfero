PROJECT = softwarepublico
VERSION = 2014.07
COMPONENTS = colab

TARBALL_FORMAT = tar.gz
TARBALLS = $(patsubst %,build/$(PROJECT)-%-$(VERSION).$(TARBALL_FORMAT),$(COMPONENTS))
RPMS = $(patsubst %.$(TARBALL_FORMAT),%-1.$(ARCH).rpm, $(TARBALLS))
GENERATED += $(TARBALLS) $(RPMS)

ARCH = $(shell uname -m)

all: sdist rpm

sdist: $(TARBALLS)

rpm: $(RPMS)

$(TARBALLS): build/$(PROJECT)-%-$(VERSION).$(TARBALL_FORMAT): %
	@echo "TAR $@"
	@mkdir -p $$(dirname $@)
	@tarball=$$(readlink -f $@); (cd ./$< && git archive --prefix=$(PROJECT)-$<-$(VERSION)/ HEAD | gzip - > $$tarball) || ($(RM) $@; false)

$(RPMS): build/$(PROJECT)-%-$(VERSION)-1.$(ARCH).rpm: build/$(PROJECT)-%-$(VERSION).$(TARBALL_FORMAT)

$(RPMS): build/$(PROJECT)-%-$(VERSION)-1.$(ARCH).rpm: rpm/%.spec
	@echo "RPM $@"
	@mkdir -p ~/rpmbuild/SOURCES
	@component=$$(basename $< .spec) && \
		ln -f build/$(PROJECT)-$$component-$(VERSION).$(TARBALL_FORMAT) ~/rpmbuild/SOURCES/ && \
		rpmbuild --quiet -bb $< && \
		ln -f ~/rpmbuild/RPMS/$(ARCH)/$(PROJECT)-$$component-$(VERSION)-1.$(ARCH).rpm $@

%.spec: %.spec.in
	@echo SPEC $@
	@(sed -e 's/@@version@@/$(VERSION)/g' $^ > $@) || ($(RM) $@; false)
GENERATED += $(patsubst %.in,%,$(wildcard rpm/*.spec.in))

clean:
	$(RM) $(GENERATED)
