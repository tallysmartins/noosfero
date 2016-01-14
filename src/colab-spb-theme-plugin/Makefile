PACKAGE = colab-spb-theme
VERSION = $(shell cat VERSION)
DISTDIR = dist
PACKAGE_NAME = $(PACKAGE)-$(VERSION)
TARBALL = $(PACKAGE_NAME).tar.gz

all:
	@echo Nothing to be $@, all good.

colab_dir=/usr/lib/colab

dist: clean
	mkdir -p $(DISTDIR)/$(PACKAGE_NAME) 
	tar --exclude=.git --exclude=$(DISTDIR) -cf - * | (cd $(DISTDIR)/$(PACKAGE_NAME) && tar xf -)
	cd $(DISTDIR) &&  tar -czf $(TARBALL) $(PACKAGE_NAME)
	rm -r $(DISTDIR)/$(PACKAGE_NAME)
clean:
	$(RM) $(TARBALL)
	$(RM) -r $(DISTDIR)

install:
	install -d -m 0755 $(DESTDIR)/$(colab_dir)/colab-spb-theme
	cp -vr colab_spb_theme  $(DESTDIR)/$(colab_dir)/colab-spb-theme
