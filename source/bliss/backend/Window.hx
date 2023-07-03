package bliss.backend;

import bliss.Project;
import bliss.engine.utilities.Signal;
import bliss.backend.graphics.BlissColor;

class Window {
	/**
	 * Makes a new window at a specified x and y position.
	 * 
	 * Specifying no position will result in a centered window.
	 */
	public static function create(title:String = "Bliss Application", ?x:Null<Int> = null, ?y:Null<Int> = null, width:Int = 640, height:Int = 480, framerate:Int = 60) {
		if(Application.self == null) {
			Debug.log(ERROR, "Application has not been initialized!");
			return null;
		}

		var window:Window = new Window();
		window._width = width;
		window._height = height;

		window.init();

		if(x != null) window.x = x;
		if(y != null) window.y = y;

		window.clearColor = Project.windowBGColor;
		window.title = title;
		window.framerate = framerate;

		_windows.push(window);

		Debug.log(SUCCESS, "Made a new window!");
		return window;
	}

	/**
	 * Whether or not this window has been closed.
	 */
	public var closed:Bool = false;

	/**
	 * The color that this window renders when nothing is on-screen.
	 */
	public var clearColor:BlissColor = BlissColor.COLOR_BLACK;

	/**
	 * The X position of the window.
	 */
	public var x(get, set):Int;

	/**
	 * The Y position of the window.
	 */
	public var y(get, set):Int;

	/**
	 * The width of the window.
	 */
	public var width(get, set):Int;

	/**
	 * The height of the window.
	 */
	public var height(get, set):Int;

	/**
	 * The framerate cap of the window.
	 */
	public var framerate(default, set):Int;

	/**
	 * The title of the window.
	 */
	public var title(default, set):String;

	/**
	 * Sets both the X and Y position of the window.
	 * All through one simple function!
	 * 
	 * @param x The X position.
	 * @param y The Y position.
	 */
	public function setPosition(x:Int = 0, y:Int = 0) {
		Rl.setWindowPosition(x, y);
	}

	/**
	 * Initializes this window's properties.
	 */
	public function init() {
		// v -- raylib stuff
		Rl.setTraceLogLevel(Rl.TraceLogLevel.WARNING);
		Rl.initWindow(Std.int(_width), Std.int(_height), "...");
		Rl.setWindowState(Rl.ConfigFlags.WINDOW_RESIZABLE);
		// ^ -- raylib stuff
	}

	/**
	 * Minimizes this window.
	 * Call the `restore()` function to unminimize it.
	 */
	public function minimize() {
		onMinimize.emit();
		Rl.minimizeWindow();
	}

	/**
	 * Maximizes this window.
	 * Call the `restore()` function to unmaximize it.
	 */
	public function maximize() {
		onMaximize.emit();
		Rl.maximizeWindow();
	}

	/**
	 * Restores this window back on-screen
	 * or to it's original size.
	 */
	public function restore() {
		onRestore.emit();
		Rl.restoreWindow();
	}

	/**
	 * Closes this window.
	 */
	public function close() {
		if(closed) return;
		onClose.emit();
		Rl.closeWindow();
		closed = true;
		_windows.remove(this);
	}

	//##-- SIGNALS --##//
	/**
	 * The signal that gets ran when the window updates.
	 */
	public var onUpdate:TypedSignal<Float->Void> = new TypedSignal();

	/**
	 * The signal that gets ran when the window renders.
	 */
	public var onRender:Signal = new Signal();

	/**
	 * The signal that gets ran when the window is about to close.
	 * 
	 * Use this to save game settings or something before the
	 * game can close!
	 */
	public var onClose:Signal = new Signal();

	/**
	 * The signal that gets ran when the window is minimized.
	 */
	public var onMinimize:Signal = new Signal();

	/**
	 * The signal that gets ran when the window is maximized.
	 */
	public var onMaximize:Signal = new Signal();

	/**
	 * The signal that gets ran when the window is restored.
	 */
	public var onRestore:Signal = new Signal();

	//##-- VARIABLES & FUNCTIONS THAT NORMALLY SHOULDN'T BE TOUCHED --##//
	/**
	 * Renders this window.
	 */
	@:noCompletion
	private function render() {
		Rl.clearBackground(clearColor.toRaylib());
		onRender.emit();
		Rl.endDrawing(); // This function in raylib stops obtaining inputs and drawing. Remove for other renderers.
	}

	/**
	 * Updates this window.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	@:noCompletion
	private function update(elapsed:Float) {
		Rl.beginDrawing(); // This function in raylib starts obtaining inputs and drawing. Remove for other renderers.
		onUpdate.emit(elapsed);
		if(!closed && Rl.windowShouldClose())
			close();
	}
	@:noCompletion
	private static var _windows:Array<Window> = [];

	//##-- Please use Window.create --##//
	@:noCompletion
	@:noPrivateAccess
	private function new() {}

	// x and y

	@:noCompletion
	private function get_x():Int {
		var die:Rl.Vector2 = cast(Rl.getWindowPosition(), Rl.Vector2);
		return Std.int(die.x);
	}

	@:noCompletion
	private function set_x(v:Int):Int {
		Rl.setWindowPosition(v, y);
		return x;
	}

	@:noCompletion
	private function get_y():Int {
		var die:Rl.Vector2 = cast(Rl.getWindowPosition(), Rl.Vector2);
		return Std.int(die.y);
	}

	@:noCompletion
	private function set_y(v:Int):Int {
		Rl.setWindowPosition(x, v);
		return v;
	}

	// w and h
	@:noCompletion
	private var _width:Int;

	@:noCompletion
	private var _height:Int;

	@:noCompletion
	private function get_width():Int {
		return _width;
	}

	@:noCompletion
	private function set_width(v:Int):Int {
		Rl.setWindowSize(Std.int(v), Std.int(_height));
		return _width = v;
	}

	@:noCompletion
	private function get_height():Int {
		return _height;
	}

	@:noCompletion
	private function set_height(v:Int):Int {
		Rl.setWindowSize(Std.int(_width), Std.int(v));
		return _height = v;
	}

	// misc
	@:noCompletion
	private function set_title(v:String):String {
		Rl.setWindowTitle(v);
		return title = v;
	}

	@:noCompletion
	private function set_framerate(v:Int):Int {
		Rl.setTargetFPS(v);
		return framerate = v;
	}
}