PACKAGE = noosfero-spb
VERSION = 3.3
DISTDIR = $(PACKAGE)-$(VERSION)
TARBALL = $(DISTDIR).tar.gz

all:
	@echo Nothing to be $@, all good.

plugin_dir=/usr/lib/noosfero/plugins/software_communities
themes_dir=/usr/lib/noosfero/public/designs/themes
noosfero_dir=/usr/lib/noosfero

dist: clean
	mkdir $(DISTDIR)
	tar --exclude=.git --exclude=$(DISTDIR) -cf - * | (cd $(DISTDIR) && tar xaf -)
	tar --exclude=.git -caf $(TARBALL) $(DISTDIR)

clean:
	$(RM) $(TARBALL)
	$(RM) -r $(DISTDIR)

install:
	install -d -m 0755 $(DESTDIR)/$(plugins_dir)/software_communities
	cp -vr software_communities/* $(DESTDIR)/$(plugins_dir)/software_communities/
	install -d -m 0755 $(DESTDIR)/$(themes_dir)/noosfero-spb-theme
	cp -vr noosfero-spb-theme/* $(DESTDIR)/$(themes_dir)/noosfero-spb-theme/
	cd $(plugin_dir) && sudo bundle exec rake
