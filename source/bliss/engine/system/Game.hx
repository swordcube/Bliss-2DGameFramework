package bliss.engine.system;

import bliss.backend.sound.SoundSystem;
import bliss.backend.Application;

import bliss.managers.*;

import bliss.engine.Scene;

enum abstract ScaleMode(Int) to Int from Int {
	/**
	 * Maintains the game's scene at a fixed size. 
	 * This will clip off the edges of the scene for dimensions which are too small, 
	 * and leave black margins on the sides for dimensions which are too large.
	 */
	var FIXED = 0;

	/**
	 * Stretches and squashes the game to exactly fit the provided window. 
	 * This may result in the graphics of your game being distorted if the user resizes their game window.
	 */
	var FILL = 1;
}

/**
 * A general class to access variables related to the current game.
 */
class Game {
	/**
	 * The currently loaded scene.
	 */
	public static var scene(get, never):Scene;

	/**
	 * The time in seconds between the last and current frame.
	 */
	public static var elapsed(get, never):Float;

	/**
	 * The framerate the game window goes to when said
	 * window is unfocused.
	 */
	public static var focusLostFramerate:Int = 10;

	/**
	 * The kind of scaling that should be applied to the game
	 * when rendering onto the window.
	 */
	public static var scaleMode:ScaleMode = FIXED;

	/**
	 * A simple way to store/remove graphics from a cache.
	 */
	public static var graphic:GraphicManager;

	/**
	 * An simple way to add/remove cameras to the game.
	 */
	public static var cameras:CameraManager;

	/**
	 * The width in pixels of the game.
	 */
	public static var width(get, set):Int;

	/**
	 * The height in pixels of the game.
	 */
	public static var height(get, set):Int;

	/**
	 * An easy variable to access keyboard input.
	 */
	public static var keys:KeyboardManager;

	/**
	 * A big list of signals that get called when the
	 * game updates, creates a scene, etc.
	 */
	public static var signals:SignalManager;

	/**
	 * The recommended way to easily play sounds.
	 * 
	 * Example:
	 * ```haxe
	 * Game.sound.play();
	 * ```
	 */
	public static var sound:SoundManager;

	/**
	 * Sets up a brand new game window.
	 * 
	 * @param framerate The maximum framerate the game is capped to.
	 * @param initialScene The scene to load when the game starts.
	 */
	public static function create(framerate:Int, initialScene:Scene) {
		// Set the framerate of the to-be created game window.
		Application.framerate = framerate;

		// Creates an application to host windows.
		// One window will be automatically made upon calling this function.
		Application.create();

		// Setup the game object
		_width = Project.windowWidth;
		_height = Project.windowHeight;

		_game = new GameObject();
		_game._requestedScene = initialScene;
		init();

		// Allow the game to automatically update and render
		var window = Application.self.window;
		window.onUpdate.connect(_game.update);
		window.onRender.connect(_game.render);

		// Allow the game to pause/resume based on if
		// the window is focused/unfocused.
		window.onFocusIn.connect(() -> {
			@:privateAccess
			window._updateFramerate(window.framerate);
			window.active = true;
		});
		window.onFocusOut.connect(() -> {
			@:privateAccess
			window._updateFramerate(Game.focusLostFramerate);
			window.active = false;
		});

		// Starts the application, thus allowing windows
		// to update and render.
		Application.start();
	}

	/**
	 * Makes the game switch to any specified scene.
	 * 
	 * @param scene The scene to switch to.
	 */
	public static function switchScene(newScene:Scene) {
		_game._requestedScene = newScene;
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private static inline function get_scene():Scene {
		return _game.scene;
	}

	@:noCompletion
	private static inline function get_elapsed():Float {
		return Application.self.deltaTime;
	}

	@:noCompletion
	private static function init() {
		// Setup helper managers
		keys = new KeyboardManager();
		graphic = new GraphicManager();
		cameras = new CameraManager();
		signals = new SignalManager();
		sound = new SoundManager();
	}

	@:noCompletion
	private static var _game:GameObject;

	@:noCompletion
	private static var _width:Int = 640;

	@:noCompletion
	private static var _height:Int = 480;

	@:noCompletion
	private static inline function get_width():Int {
		return _width;
	}

	@:noCompletion
	private static inline function set_width(v:Int):Int {
		var window = Application.self.window;
		window.width = v;
		return _width = v;
	}

	@:noCompletion
	private static inline function get_height():Int {
		return _height;
	}

	@:noCompletion
	private static inline function set_height(v:Int):Int {
		var window = Application.self.window;
		window.height = v;
		return _height = v;
	}
}