VERSION = $(shell cat ../VERSION)
subdirs = colab-spb-plugin colab-spb-theme-plugin noosfero-spb

dist_all = $(patsubst %, %-dist, $(subdirs))
dist: $(dist_all)
$(dist_all): %-dist : %
	if [ -f $*/Makefile ]; then make -C $* dist; fi
	if [ -f $*/setup.py ]; then (cd $* && python setup.py sdist); fi

clean_all = $(patsubst %, %-clean, $(subdirs))
clean: $(clean_all)
	$(MAKE) -C pkg-rpm/ clean

$(clean_all): %-clean : %
	if [ -f $*/Makefile ]; then make -C $* clean; fi
	if [ -f $*/setup.py ]; then rm -rf $*/dist; fi

release:
	@if git tag | grep -q '^v$(VERSION)$$'; then \
		echo "E: version $(VERSION) already tagged. You need a new version number"; \
		false; \
	fi
	echo '$(VERSION)' > colab-spb-plugin/VERSION
	echo '$(VERSION)' > colab-spb-theme-plugin/VERSION
	echo '$(VERSION)' > noosfero-spb/VERSION
	$(MAKE) dist
	cp noosfero-spb/dist/*.tar.* pkg-rpm/noosfero-spb/
	cp colab-spb-theme-plugin/dist/*.tar.* pkg-rpm/colab-spb-theme/
	cp colab-spb-plugin/dist/*.tar.* pkg-rpm/colab-spb-plugin/
	sed -i -e 's/^\(Version:\s*\).*/\1$(VERSION)/' \
		pkg-rpm/colab-spb-theme/colab-spb-theme.spec \
		pkg-rpm/colab-spb-plugin/colab-spb-plugin.spec \
		pkg-rpm/noosfero-spb/noosfero-spb.spec
	git diff
	@printf "Confirm release? [y/N]"; \
		read confirm; \
		if [ "$$confirm" = 'y' -o "$$confirm" = 'Y' ]; then \
			echo "SPB release $(VERSION)" > .commit_template; \
			git commit * --file .commit_template; \
			rm -f .commit_template; \
		else \
			echo 'Aborting at your request!'; \
			git checkout -- colab-spb-theme-plugin/VERSION noosfero-spb/VERSION colab-spb-plugin/VERSION  ; \
			git checkout -- pkg-rpm/colab-spb-theme/ pkg-rpm/noosfero-spb/ pkg-rpm/colab-spb-plugin/  ; \
			false; \
		fi
	# TODO add pkg-rpm/colab-spb-plugin to the git checkout all above
	$(MAKE) -C pkg-rpm/ noosfero-spb-upload colab-spb-theme-upload colab-spb-plugin-upload
	git tag $(VERSION) -s -m 'SPB Release $(VERSION)'
