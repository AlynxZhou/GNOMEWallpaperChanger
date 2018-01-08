namespace UPower {
	public const string NAME = "org.freedesktop.UPower";
	public const string PATH = "/org/freedesktop/UPower";
	public const uint LINE_POWER = 1;

	[DBus (name = "org.freedesktop.UPower")]
	interface UPower : Object {
		public signal void changed();
		public abstract bool on_battery { owned get; }
		public abstract bool low_on_battery { owned get; }
		public abstract ObjectPath[] enumerate_devices() throws IOError;
	}

	[DBus (name = "org.freedesktop.UPower.Device")]
	interface Device : Object {
		public signal void changed();
		public abstract void refresh() throws IOError;
		public abstract bool online { owned get; }
		public abstract bool power_supply { owned get; }
		public abstract bool is_present { owned get; }
		[DBus (name = "Type")]
		public abstract uint device_type { owned get; }
	}
}
