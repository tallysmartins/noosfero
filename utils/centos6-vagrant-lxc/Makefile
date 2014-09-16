BOX = centos6
TEMPLATE_ARGS = -t centos -- --release 6.5
LXC_PATH := $(shell sudo lxc-config lxc.lxcpath)

$(BOX).box: metadata.json lxc.conf lxc-template rootfs.tar.gz
	$(RM) $@
	tar czf $@ $^

rootfs.tar.gz: rootfs
	$(RM) $@
	sudo tar czfp $@ ./rootfs

foo: .$(BOX)-base
	cp -dR --preserve=mode,ownership /etc/vim foo

rootfs: .$(BOX)-base
	sudo cp -dR --preserve=mode,ownership $(LXC_PATH)/$(BOX)-base/rootfs rootfs
	sudo ./vagrant-setup rootfs

lxc.conf: .$(BOX)-base
	sed -e '/^lxc.rootfs\s*=/d' $(LXC_PATH)/$(BOX)-base/config > $@ || ($(RM) $@; false)

.$(BOX)-base:
	sudo lxc-create -n $(BOX)-base $(TEMPLATE_ARGS)
	touch $@

.PHONY: install uninstall clean

metadata.json: metadata.json.in
	./metadata.json.in > $@

uninstall:
	vagrant box remove $(BOX)

install: $(BOX).box
	vagrant box add $(BOX) $^

clean:
	$(RM) $(BOX).box

fullclean: clean
	sudo $(RM) -r rootfs
	sudo $(RM) rootfs.tar.gz
	$(RM) .$(BOX)-base
	$(RM) lxc.conf
	$(RM) metadata.json
	sudo lxc-destroy -n $(BOX)-base
