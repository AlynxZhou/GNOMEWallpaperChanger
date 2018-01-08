public class GNOMEWallpaperChanger : Object {
	private int seconds = 5 * 60;
	private string option = "zoom";
	private bool recursive = false;
	private bool powersave = false;
	private string[] dirs = {};
	private string[] files = {};
	private const string[] picture_types = { "png", "webp", "jpg", "jpeg", "bmp" };
	private Settings wallpaper_settings = new Settings("org.gnome.desktop.background");
	private UPower.UPower? upower = null;

	public GNOMEWallpaperChanger(int s = 5 * 60, string[] d = { "./" }, bool r = false, string o = "zoom", bool p = false) {
		seconds = s;
		if (seconds == 0)
			seconds = 5 * 60;
		dirs = d;
		recursive = r;
		option = o;
		powersave = p;
	}

	private UPower.UPower connect_upower() throws IOError {
		return upower = Bus.get_proxy_sync(BusType.SYSTEM, UPower.NAME, UPower.PATH, DBusProxyFlags.NONE);
	}

	private UPower.Device get_power_device(UPower.UPower u) throws IOError {
		ObjectPath[] devs = u.enumerate_devices();
		for (int i = 0; i < devs.length; i++) {
			UPower.Device dev = Bus.get_proxy_sync(BusType.SYSTEM, UPower.NAME, devs[i], DBusProxyFlags.GET_INVALIDATED_PROPERTIES);
			if (dev.device_type == UPower.LINE_POWER)
				return dev;
		}
		throw new IOError.NOT_FOUND("UPower Line Power Not Found");
	}

	private bool check_power(UPower.Device upower_device) throws IOError {
		if (upower_device != null) {
			upower_device.refresh();
			if (upower_device.online && upower_device.power_supply) {
				return true;
			}
		}
		return false;
	}

	private int get_enum_option(string option) {
		switch (option) {
		case "none":
			return 0;
		case "wallpaper":
			return 1;
		case "centered":
			return 2;
		case "scaled":
			return 3;
		case "stretched":
			return 4;
		case "zoom":
			return 5;
		case "spanned":
			return 6;
		default:
			return 5;
		}
	}

	private void read_dir(string dir_name, bool recursive) throws FileError {
		if (!FileUtils.test(dir_name, FileTest.IS_DIR))
			return;
		Dir dir = Dir.open(dir_name);
		for (string? file_name = null; (file_name = dir.read_name()) != null; ) {
			string[] file_name_list = file_name.split(".");
			if (recursive && FileUtils.test(Path.build_filename(dir_name, file_name), FileTest.IS_DIR)) {
				read_dir(Path.build_filename(dir_name, file_name), recursive);
			} else if (file_name_list[file_name_list.length - 1] in picture_types) {
				// To get a absolute path of file must
				// open it, and use get_path() method.
				// Maybe better way here?
				File dir_file = File.new_for_path(Path.build_filename(dir_name, file_name));
				files += dir_file.get_path();
			}
		}
	}

	public void main_loop() throws IOError, FileError {
		if (powersave)
			upower = connect_upower();
		// Read dir first.
		files = {};
		foreach (string dir_name in dirs)
			read_dir(dir_name, recursive);
		// Align to the first second of a minute.
		int second_now = new DateTime.now_utc().get_second();
		Thread.usleep((seconds - second_now % seconds) * 1000 * 1000 - 300 * 1000);
		for (int i = 0; files.length != 0; Thread.usleep(seconds * 1000 * 1000)) {
			if (i >= files.length)
				i = 0;
			if (powersave && !check_power(get_power_device(upower)))
				continue;
			// Refresh dir every loop.
			files = {};
			foreach (string dir_name in dirs)
				read_dir(dir_name, recursive);
			stdout.printf("gsettings set org.gnome.desktop.background picture-uri \"file://%s\"\n", files[i]);
			wallpaper_settings.set_string("picture-uri", "file://" + files[i]);
			stdout.printf("gsettings set org.gnome.desktop.background picture-options \"%s\"\n", option);
			wallpaper_settings.set_enum("picture-options", get_enum_option(option));
			++i;
		}
	}
}
