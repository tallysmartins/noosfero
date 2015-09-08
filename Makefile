PACKAGE = colab-spb-theme-plugin
VERSION = 0.2
DISTDIR = $(PACKAGE)-$(VERSION)
TARBALL = $(DISTDIR).tar.gz

all:
	@echo Nothing to be $@, all good.

colab_dir=/usr/lib/colab

dist: clean
	mkdir $(DISTDIR)
	tar --exclude=.git --exclude=$(DISTDIR) -cf - * | (cd $(DISTDIR) && tar xaf -)
	tar --exclude=.git -caf $(TARBALL) $(DISTDIR)
	rm ~/rpmbuild/SOURCES/$(TARBALL) && cp $(TARBALL) ~/rpmbuild/SOURCES/
clean:
	$(RM) $(TARBALL)
	$(RM) -r $(DISTDIR)

install:
	install -d -m 0755 $(DESTDIR)/$(colab_dir)/colab-spb-theme-plugin
	cp -vr .  $(DESTDIR)/$(colab_dir)/colab-spb-theme-plugin
