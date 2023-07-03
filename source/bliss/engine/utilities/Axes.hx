package bliss.engine.utilities;

import bliss.backend.Debug;

enum abstract Axes(Int) {
	var X = 0x01;
	var Y = 0x10;
	var XY = 0x11;
	var NONE = 0x00;

	/**
	 * Whether the horizontal axis is anebled
	 */
	public var x(get, never):Bool;

	/**
	 * Whether the vertical axis is anebled
	 */
	public var y(get, never):Bool;

	/**
	 * Internal helper to reference self
	 */
	var self(get, never):Axes;

	inline function get_self():Axes {
		return cast this;
	}

	inline function get_x() {
		return self == X || self == XY;
	}

	inline function get_y() {
		return self == Y || self == XY;
	}

	public function toString():String {
		return switch(self) {
			case X: "x";
			case Y: "y";
			case XY: "xy";
			case NONE: "none";
		}
	}

	public static function fromBools(x:Bool, y:Bool):Axes {
		return cast(x ? (cast X : Int) : 0) | (y ? (cast Y : Int) : 0);
	}

	public static function fromString(axes:String):Axes {
		switch(axes.toLowerCase()) {
			case "x": return X;
			case "y": return Y;
			case "xy", "yx", "both": return XY;
			case "none", "", null: return NONE;
			default: 
				Debug.log(WARNING, "Invalid axes value: "+axes);
				return NONE;
		}
	}
}
