BOX = centos6
TEMPLATE_ARGS = -t centos -- --release 6.5
LXC_PATH := $(shell sudo lxc-config lxc.lxcpath)

all: $(BOX).box

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
	sed -e '/^lxc.rootfs\s*=/d; s/lxc.autodev\s*=.*/lxc.autodev = 1/' $(LXC_PATH)/$(BOX)-base/config > $@ || ($(RM) $@; false)

.$(BOX)-base:
	sudo lxc-create -n $(BOX)-base $(TEMPLATE_ARGS)
	touch $@

.PHONY: install uninstall clean

metadata.json: metadata.json.in
	./metadata.json.in > $@

uninstall:
	vagrant box remove $(BOX) || true

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
	if sudo lxc-ls | grep $(BOX)-base; then sudo lxc-destroy -n $(BOX)-base; fi

retry: clean uninstall all install
	vagrant up
