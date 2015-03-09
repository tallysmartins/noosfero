all clean:
	@echo Nothing to be $@, all good.

plugins_dir=/usr/lib/noosfero/plugins
themes_dir=/usr/lib/noosfero/public/designs/themes

install:
	install -d -m 0755 $(DESTDIR)/$(plugins_dir)/software_communities
	cp -vr software_communities/* $(DESTDIR)/$(plugins_dir)/software_communities/
	install -d -m 0755 $(DESTDIR)/$(themes_dir)/noosfero-spb-theme
	cp -vr noosfero-spb-theme/* $(DESTDIR)/$(themes_dir)/noosfero-spb-theme/

