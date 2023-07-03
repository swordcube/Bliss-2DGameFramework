package bliss.engine.system;

import bliss.engine.Scene;
import bliss.backend.Application;

class Game {
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

		// Starts the application, thus allowing windows
		// to update and render.
		Application.start();
	}
}