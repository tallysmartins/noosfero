PROJECT = softwarepublico
VERSION = $(shell git describe --tags || date +%Y.%d)

TARBALL = dist/$(PROJECT)-$(VERSION).tar.gz

all:

sdist: $(TARBALL)

$(TARBALL): $(shell git ls-files)
	@if [ -n "$$(git diff-index HEAD)" ]; then echo "Cannot proceed with uncommitted changes"; false; fi
	mkdir -p $$(dirname $@)
	(git archive --prefix=$(PROJECT)-$(VERSION)/ HEAD | gzip -) > $@

clean:

distclean: clean
	$(RM) -r dist
