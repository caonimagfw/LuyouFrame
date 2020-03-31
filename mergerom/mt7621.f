#
# MT7621 Profiles
#

KERNEL_DTB += -d21
DEVICE_VARS += TPLINK_BOARD_ID TPLINK_HEADER_VERSION TPLINK_HWID TPLINK_HWREV

define Build/elecom-wrc-factory
  $(eval product=$(word 1,$(1)))
  $(eval version=$(word 2,$(1)))
  $(STAGING_DIR_HOST)/bin/mkhash md5 $@ >> $@
  ( \
    echo -n "ELECOM $(product) v$(version)" | \
      dd bs=32 count=1 conv=sync; \
    dd if=$@; \
  ) > $@.new
  mv $@.new $@
endef

define Build/ubnt-erx-factory-image
	if [ -e $(KDIR)/tmp/$(KERNEL_INITRAMFS_IMAGE) -a "$$(stat -c%s $@)" -lt "$(KERNEL_SIZE)" ]; then \
		echo '21001:6' > $(1).compat; \
		$(TAR) -cf $(1) --transform='s/^.*/compat/' $(1).compat; \
		\
		$(TAR) -rf $(1) --transform='s/^.*/vmlinux.tmp/' $(KDIR)/tmp/$(KERNEL_INITRAMFS_IMAGE); \
		mkhash md5 $(KDIR)/tmp/$(KERNEL_INITRAMFS_IMAGE) > $(1).md5; \
		$(TAR) -rf $(1) --transform='s/^.*/vmlinux.tmp.md5/' $(1).md5; \
		\
		echo "dummy" > $(1).rootfs; \
		$(TAR) -rf $(1) --transform='s/^.*/squashfs.tmp/' $(1).rootfs; \
		\
		mkhash md5 $(1).rootfs > $(1).md5; \
		$(TAR) -rf $(1) --transform='s/^.*/squashfs.tmp.md5/' $(1).md5; \
		\
		echo '$(BOARD) $(VERSION_CODE) $(VERSION_NUMBER)' > $(1).version; \
		$(TAR) -rf $(1) --transform='s/^.*/version.tmp/' $(1).version; \
		\
		$(CP) $(1) $(BIN_DIR)/; \
	else \
		echo "WARNING: initramfs kernel image too big, cannot generate factory image" >&2; \
	fi
endef

define Device/mt7621
  DTS := MT7621
  BLOCKSIZE := 64k
  IMAGE_SIZE := $(ralink_default_fw_size_4M)
  DEVICE_TITLE := MediaTek MT7621 EVB
endef
TARGET_DEVICES += mt7621

define Device/newifi-d1
  DTS := Newifi-D1
  IMAGE_SIZE := $(ralink_default_fw_size_32M)
  DEVICE_TITLE := Newifi D1
  DEVICE_PACKAGES := \
	kmod-mt7603 kmod-mt76x2 kmod-usb3 kmod-usb-ledtrig-usbport wpad-mini
endef
TARGET_DEVICES += newifi-d1

define Device/d-team_newifi-d2
  DTS := Newifi-D2
  IMAGE_SIZE := $(ralink_default_fw_size_32M)
  DEVICE_TITLE := Newifi D2
  DEVICE_PACKAGES := \
	kmod-mt7603 kmod-mt76x2 kmod-usb3 kmod-usb-ledtrig-usbport wpad-mini
endef
TARGET_DEVICES += d-team_newifi-d2

# FIXME: is this still needed?
define Image/Prepare
#define Build/Compile
	rm -rf $(KDIR)/relocate
	$(CP) ../../generic/image/relocate $(KDIR)
	$(MAKE) -C $(KDIR)/relocate KERNEL_ADDR=$(KERNEL_LOADADDR) CROSS_COMPILE=$(TARGET_CROSS)
	$(CP) $(KDIR)/relocate/loader.bin $(KDIR)/loader.bin
endef
