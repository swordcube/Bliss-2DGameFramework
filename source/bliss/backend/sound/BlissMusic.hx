package bliss.backend.sound;

import bliss.managers.MusicManager;
import bliss.engine.utilities.typeLimit.*;
import bliss.backend.interfaces.IDestroyable;

typedef BlissMusicAsset = OneOfTwo<String, BlissMusic>;

/**
 * A wrapper for raylib music.
 * 
 * Prevents compiler conflicts.
 */
class BlissMusic implements IDestroyable {
	/**
	 * The linked music.
	 */
	public var music:Rl.Music;

	/**
	 * The key/name of this graphic.
	 */
	public var key:String;

	/**
	 * The amount of times this music has been used.
	 */
	public var useCount(default, set):Int = 0;

	/**
	 * Loads music data from a given file path.
	 * 
	 * @param path  The file path of the music data to load.
	 * @param key   The key of already stored music to try and load.
	 */
	 public static function fromFile(path:String, ?key:String):BlissMusic {
		if(key == null) key = path;

		@:privateAccess
		if(MusicManager.isCached(key))
			return MusicManager.get(key);
		else {
			var music:BlissMusic = new BlissMusic();
			music.music = Rl.loadMusicStream(path);
			music.key = path;
			return MusicManager.cacheMusic(music);
		}
	}

	/**
	 * Destroys this music, making it potentially
	 * unusable afterwards!
	 */
	public function destroy() {
		Rl.unloadMusicStream(music);
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
		if(v > -1 && v < 1 && !destroyed)
			destroy();

		return useCount = v;
	}
}
