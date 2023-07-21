package bliss.backend.sound;

import bliss.backend.interfaces.IDestroyable;

import bliss.engine.system.Game;
import bliss.engine.utilities.typeLimit.*;

typedef BlissSoundAsset = OneOfTwo<String, BlissSound>;

/**
 * A wrapper for a raylib sound.
 * 
 * Prevents compiler conflicts.
 */
class BlissSound implements IDestroyable {
	/**
	 * The linked sound.
	 */
	public var sound:Rl.Sound;

	/**
	 * The key/name of this graphic.
	 */
	public var key:String;

	/**
	 * The amount of times this sound has been used.
	 */
	public var useCount(default, set):Int = 0;

	/**
	 * Loads sound data from a given file path.
	 * 
	 * @param path  The file path of the sound data to load.
	 * @param key   The key of an already stored sound to try and load.
	 */
	public static function fromFile(path:String, ?key:String):BlissSound {
		if(key == null) key = path;
		
		@:privateAccess
		if(Game.sound.isCached(key))
			return Game.sound.get(key);
		else {
			var sound:BlissSound = new BlissSound();
			sound.sound = Rl.loadSound(path);
			sound.key = path;
			return Game.sound.cacheSound(sound);
		}
	}

	/**
	 * Destroys this sound, making it potentially
	 * unusable afterwards!
	 */
	public function destroy() {
		Rl.unloadSound(sound);
		destroyed = true;
		useCount = -1;
	}

	// ##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	/**
	 * Used internally, please use the static helper functions.
	 */
	@:noCompletion
	private function new() {}

	@:noCompletion
	private var destroyed:Bool = false;

	@:noCompletion
	private function set_useCount(v:Int) {
		if(v < 1 && !destroyed)
			destroy();
		
		return useCount = v;
	}
}
