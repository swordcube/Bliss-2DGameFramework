package bliss.backend;

import haxe.PosInfos;

using bliss.engine.utilities.ArrayUtil;

enum abstract LogType(Int) from Int to Int {
	var GENERAL = 0;
	var WARNING;
	var ERROR;
	var SUCCESS;
}

/**
 * A simple class used to print things to the console.
 * 
 * This will print to a GUI console and a standard one in the future.
 */
class Debug {
	/**
	 * The default haxe trace function.
	 * 
	 * Usually `trace("something")` would call `Debug.log(GENERAL, "something")`.
	 * But if you absolutely need haxe tracing, just call this instead!
	 */
	public static var haxeTrace:Dynamic;

	/**
	 * Logs any content to the console if possible.
	 * 
	 * @param type The type of log to print, general, warning, error, etc.
	 * @param content The content to print/log.
	 */
	public static inline function log(type:LogType, content:Dynamic, ?infos:PosInfos) {
		var classPrefix:String = "[ "+infos.className.split(".").last()+"."+infos.methodName+":"+infos.lineNumber+" ]";
		var prefix:String = switch(type) {
			case WARNING: "[ WARNING ]";
			case ERROR:   "[  ERROR  ]";
			case SUCCESS: "[ SUCCESS ]";
			default:      "[  BLISS  ]";
		};
		Sys.println(classPrefix+" "+prefix+" "+Std.string(content));
	}
}