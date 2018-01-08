GNOMEWallpaperChanger
=====================

GNOME Wallpaper Auto Changer

# Usage

## Build

1. Dependency

	- GNOME

	- Vala

	- GLib, Gio, DBus, UPower

2. Simply `$ make`

## Run

```bash
$ ./bin/gnome-wallpaper-changer -h
```

Example:

```bash
$ nohup ./bin/gnome-wallpaper-changer -rps 60 -o zoom ~/Pictures/Wallpapers >> /dev/null 2>&1 &
```

will run this independently, it use `~/Pictures/Wallpapers` as wallpaper dir, and will look for pictures recursively, change wallpaper every 60 seconds, picture option will be `zoom`, and with powersave mode it won't change wallpaper when you are usin g battery.

# Why write this?

GNOME has built in auto change wallpaper function, via creating a xml file contains when to change to which file. But it works horribly, it will mix old and new wallpaper then pause and replace with new one after one second, but if you manually change wallpaper it will have a smooth mix and change. So I write this small program which do gsettings automatically, with Vala, it only use 700KB memory (sometimes 2.7MB when you launch it, I think it's Vala's issue, anyway it won't grow up).
