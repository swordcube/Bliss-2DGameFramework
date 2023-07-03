package bliss.engine.system;

import bliss.engine.Scene;
import bliss.backend.Application;

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
		_game = new GameObject();
		_game._requestedScene = initialScene;

		// Allow the game to automatically update
		var window = Application.self.window;
		window.onUpdate.connect(_game.update);

		// Starts the application, thus allowing windows
		// to update and render.
		Application.start();
	}

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
	private static var _game:GameObject;
}