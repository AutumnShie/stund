# 
# Copyright (C) 2008-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=stund
PKG_VERSION:=0.97
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=@SF/stun
PKG_MD5SUM:=097fd27829e357c005afcafd51564bd1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk

define Package/stun/Default
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=$(CXX_DEPENDS)
  URL:=http://sourceforge.net/projects/stun
endef

define Package/stun/Default/description
  The STUN protocol (Simple Traversal of UDP through NATs) is described in the
  IETF RFC 3489, available at http://www.ietf.org/rfc/rfc3489.txt. It's used to
  help clients behind NAT to tunnel incoming calls through. This server is the
  counterpart to help the client identify the NAT and have it open the proper
  ports for it.
endef

define Package/stund
$(call Package/stun/Default)
  TITLE:=STUN server
endef

define Package/stund/description
$(call Package/stun/Default/description)
endef

define Package/stun-client
$(call Package/stun/Default)
  TITLE:=STUN test client
endef

define Package/stun-client/description
$(call Package/stun/Default/description)
endef

define Package/stund/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/server $(1)/usr/sbin/stund
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/stund.init $(1)/etc/init.d/stund
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/stund.config $(1)/etc/config/stund
endef

define Package/stund/conffiles
/etc/config/stund
endef

define Package/stun-client/install
 	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/client $(1)/usr/sbin/stun-client
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/stun-client.init $(1)/etc/init.d/stun-client
	$(INSTALL_DIR) $(1)/etc/hotplug.d/cwmp/
	$(INSTALL_BIN) ./files/01-stun_client.hotplug $(1)/etc/hotplug.d/cwmp/01-stun_client
endef

$(eval $(call BuildPackage,stund))
$(eval $(call BuildPackage,stun-client))