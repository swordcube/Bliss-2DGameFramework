package bliss.backend.input;

import bliss.backend.macros.MacroUtil;

enum abstract KeyState(Int) to Int from Int {
	var JUST_PRESSED = 0;
	var PRESSED = 1;
	var JUST_RELEASED = 2;
	var RELEASED = 3;
}

/**
 * Maps enum values and strings to integer keycodes.

 * @see https://github.com/HaxeFlixel/flixel/blob/master/flixel/input/keyboard/FlxKey.hx
 * @see https://github.com/raysan5/raylib/blob/master/src/raylib.h#LL541C3-L541C3
 */
enum abstract Keys(Int) from Int to Int {
	public static var fromStringMap(default, null):Map<String, Keys> = MacroUtil.buildMap("bliss.backend.input.Keys");
	public static var toStringMap(default, null):Map<Keys, String> = MacroUtil.buildMap("bliss.backend.input.Keys", true);

	var ANY = -1; // Key: ANY; used for any key pressed
	var NONE = 0; // Key: NULL; used for no key pressed

	// Alphanumeric keys
	var APOSTROPHE = 39; // Key: '
	var COMMA = 44; // Key: ;
	var MINUS = 45; // Key: -
	var PERIOD = 46; // Key: .
	var SLASH = 47; // Key: /
	var ZERO = 48; // Key: 0
	var ONE = 49; // Key: 1
	var TWO = 50; // Key: 2
	var THREE = 51; // Key: 3
	var FOUR = 52; // Key: 4
	var FIVE = 53; // Key: 5
	var SIX = 54; // Key: 6
	var SEVEN = 55; // Key: 7
	var EIGHT = 56; // Key: 8
	var NINE = 57; // Key: 9
	var SEMICOLON = 59; // Key: ;
	var PLUS = 61; // Key: =
	var A = 65; // Key: A | a
	var B = 66; // Key: B | b
	var C = 67; // Key: C | c
	var D = 68; // Key: D | d
	var E = 69; // Key: E | e
	var F = 70; // Key: F | f
	var G = 71; // Key: G | g
	var H = 72; // Key: H | h
	var I = 73; // Key: I | i
	var J = 74; // Key: J | j
	var K = 75; // Key: K | k
	var L = 76; // Key: L | l
	var M = 77; // Key: M | m
	var N = 78; // Key: N | n
	var O = 79; // Key: O | o
	var P = 80; // Key: P | p
	var Q = 81; // Key: Q | q
	var R = 82; // Key: R | r
	var S = 83; // Key: S | s
	var T = 84; // Key: T | t
	var U = 85; // Key: U | u
	var V = 86; // Key: V | v
	var W = 87; // Key: W | w
	var X = 88; // Key: X | x
	var Y = 89; // Key: Y | y
	var Z = 90; // Key: Z | z
	var LEFT_BRACKET = 91; // Key: [
	var BACKSLASH = 92; // Key: '\'
	var RIGHT_BRACKET = 93; // Key: ]
	var GRAVE = 96; // Key: `
	// Function keys
	var SPACE = 32; // Key: Space
	var ESCAPE = 256; // Key: Esc
	var ENTER = 257; // Key: Enter
	var TAB = 258; // Key: Tab
	var BACKSPACE = 259; // Key: Backspace
	var INSERT = 260; // Key: Ins
	var DELETE = 261; // Key: Del
	var RIGHT = 262; // Key: Cursor right
	var LEFT = 263; // Key: Cursor left
	var DOWN = 264; // Key: Cursor down
	var UP = 265; // Key: Cursor up
	var PAGE_UP = 266; // Key: Page up
	var PAGE_DOWN = 267; // Key: Page down
	var HOME = 268; // Key: Home
	var END = 269; // Key: End
	var CAPS_LOCK = 280; // Key: Caps lock
	var SCROLL_LOCK = 281; // Key: Scroll down
	var NUM_LOCK = 282; // Key: Num lock
	var PRINT_SCREEN = 283; // Key: Print screen
	var PAUSE = 284; // Key: Pause
	var F1 = 290; // Key: F1
	var F2 = 291; // Key: F2
	var F3 = 292; // Key: F3
	var F4 = 293; // Key: F4
	var F5 = 294; // Key: F5
	var F6 = 295; // Key: F6
	var F7 = 296; // Key: F7
	var F8 = 297; // Key: F8
	var F9 = 298; // Key: F9
	var F10 = 299; // Key: F10
	var F11 = 300; // Key: F11
	var F12 = 301; // Key: F12
	var LEFT_SHIFT = 340; // Key: Shift left
	var LEFT_CONTROL = 341; // Key: Control left
	var LEFT_ALT = 342; // Key: Alt left
	var LEFT_SUPER = 343; // Key: Super left
	var RIGHT_SHIFT = 344; // Key: Shift right
	var RIGHT_CONTROL = 345; // Key: Control right
	var RIGHT_ALT = 346; // Key: Alt right
	var RIGHT_SUPER = 347; // Key: Super right
	var KB_MENU = 348; // Key: KB menu
	// Numpad keys
	var NUMPAD_ZERO = 320; // Key: Numpad 0
	var NUMPAD_ONE = 321; // Key: Numpad 1
	var NUMPAD_TWO = 322; // Key: Numpad 2
	var NUMPAD_THREE = 323; // Key: Numpad 3
	var NUMPAD_FOUR = 324; // Key: Numpad 4
	var NUMPAD_FIVE = 325; // Key: Numpad 5
	var NUMPAD_SIX = 326; // Key: Numpad 6
	var NUMPAD_SEVEN = 327; // Key: Numpad 7
	var NUMPAD_EIGHT = 328; // Key: Numpad 8
	var NUMPAD_NINE = 329; // Key: Numpad 9
	var NUMPAD_PERIOD = 330; // Key: Numpad .
	var NUMPAD_SLASH = 331; // Key: Numpad /
	var NUMPAD_MULTIPLY = 332; // Key: Numpad *
	var NUMPAD_MINUS = 333; // Key: Numpad -
	var NUMPAD_PLUS = 334; // Key: Numpad +
	var NUMPAD_ENTER = 335; // Key: Numpad Enter
	var NUMPAD_EQUAL = 336; // Key: Numpad =

	@:from
	public static inline function fromString(s:String) {
		s = s.toUpperCase();
		return fromStringMap.exists(s) ? fromStringMap.get(s) : NONE;
	}

	@:to
	public inline function toString():String {
		return toStringMap.get(this);
	}
}