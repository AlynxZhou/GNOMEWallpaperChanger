PKGS ?= --pkg gio-2.0 --pkg glib-2.0
SOURCES := src/GNOMEWallpaperChanger.vala src/UPower.vala src/Main.vala

gnome-wallpaper-changer: ${SOURCES}
	valac ${PKGS} -o bin/gnome-wallpaper-changer ${SOURCES}

.PHONY: debug
debug: ${SOURCES}
	valac -g ${PKGS} -o bin/gnome-wallpaper-changer_debug ${SOURCES}

.PHONY: install
install:
	install -o root -m 0755 -D bin/gnome-wallpaper-changer /usr/bin/gnome-wallpaper-changer

.PHONY: uninstall
uninstall:
	-rm -f /usr/bin/gnome-wallpaper-changer

.PHONY: clean
clean:
	-rm -f bin/gnome-wallpaper-changer bin/gnome-wallpaper-changer_debug

.PHONY: rebuild
rebuild: clean gnome-wallpaper-changer
