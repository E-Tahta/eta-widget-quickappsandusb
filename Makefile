all: install

install:
	mkdir -p $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/
	@cp -fr tr.org.etap.quickappsandusb $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/

	mkdir -p $(DESTDIR)/usr/share/kde4/services
	@cp -fr tr.org.etap.quickappsandusb/metadata.desktop $(DESTDIR)/usr/share/kde4/services/eta-widget-quickappsandusb.desktop

uninstall:
	@rm -fr $(DESTDIR)/usr/share/kde4/services/eta-widget-quickappsandusb.desktop
	@rm -fr $(DESTDIR)/usr/share/kde4/apps/plasma/plasmoids/tr.org.etap.quickappsandusb

.PHONY: install uninstall
