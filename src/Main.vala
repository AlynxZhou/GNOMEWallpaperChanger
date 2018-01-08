public class Main : Object {
	private static int seconds = 5 * 60;
	private static bool version = false;
	private static bool recursive = false;
	private static bool powersave = false;
	private static string? option = "zoom";
	[CCode (array_length = false, array_null_terminated = true)]
	private static string[] dirs;
	private const OptionEntry[] options = {
		// --version || -v
		{ "version", 'v', 0, OptionArg.NONE, ref version, "Display version number.", null },
		// --recursive || -r
		{ "recursive", 'r', 0, OptionArg.NONE, ref recursive, "Read dirs recursively.", null },
		// --recursive || -r
		{ "powersave", 'p', 0, OptionArg.NONE, ref powersave, "Disable changer when using battery.", null },
		// --seconds=SECONDS || -s SECONDS
		{ "seconds", 's', 0, OptionArg.INT, ref seconds, "Interval in seconds.", "SECONDS" },
		// --option=OPTION || -o OPTION
		{ "option", 'o', 0, OptionArg.STRING, ref option, "Wallpaper options.", "none|wallpaper|centered|scaled|stretched|zoom|spanned" },
		// DIRS
		{ "", 0, 0, OptionArg.FILENAME_ARRAY, ref dirs, "Wallpaper directories.", "DIR..." },
		// list terminator
		{ null }
	};

	public static int main(string[] args) {
		string version_str = "0.1.1";
		try {
			OptionContext option_context = new OptionContext("- GNOME Wallpaper Auto Changer");
			option_context.set_help_enabled(true);
			option_context.add_main_entries(options, null);
			option_context.parse(ref args);
			if (version) {
				stdout.printf("%s\n", version_str);
				return 0;
			}
			if (option == null)
				option = "zoom";
			new GNOMEWallpaperChanger(seconds, dirs, recursive, option, powersave).main_loop();
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
			stderr.printf("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return 1;
		}
		return 0;
	}
}
