
BRIDGE_VLAN_IFSCRIPTS_LICENSE = GPL-2.0
BRIDGE_VLAN_IFSCRIPTS_LICENSE_FILES = COPYING

define BRIDGE_VLAN_IFSCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -d $(TARGET_DIR)/etc/network/if-up.d/
	$(INSTALL) -m 755 -d $(TARGET_DIR)/etc/network/if-pre-up.d/
	$(INSTALL) -m 755 -d $(TARGET_DIR)/etc/network/if-post-down.d/
	$(INSTALL) -D -m 755 ../general/package/bridge-vlan-ifscripts/bridge_if-post-down \
		$(TARGET_DIR)/etc/network/if-post-down.d/bridge
	$(INSTALL) -D -m 755 ../general/package/bridge-vlan-ifscripts/vlan_if-post-down \
		$(TARGET_DIR)/etc/network/if-post-down.d/vlan
	$(INSTALL) -D -m 755 ../general/package/bridge-vlan-ifscripts/bridge_if-pre-up \
		$(TARGET_DIR)/etc/network/if-pre-up.d/bridge
	$(INSTALL) -D -m 755 ../general/package/bridge-vlan-ifscripts/vlan_if-pre-up \
		$(TARGET_DIR)/etc/network/if-pre-up.d/vlan
	$(INSTALL) -D -m 755 ../general/package/bridge-vlan-ifscripts/bridge_if-up \
		$(TARGET_DIR)/etc/network/if-up.d/bridge
endef

$(eval $(generic-package))
