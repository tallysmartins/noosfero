PROJECT = softwarepublico
VERSION ?= $(shell date +%Y.%m.%d)

TARBALL = dist/$(PROJECT)-$(VERSION).tar.gz

all:

sdist: $(TARBALL)

$(TARBALL): $(shell git ls-files)
	mkdir -p $$(dirname $@)
	(git archive --prefix=$(PROJECT)-$(VERSION)/ HEAD | gzip -) > $@

clean:

distclean: clean
	$(RM) -r dist
