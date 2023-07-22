package bliss.managers;

import bliss.backend.sound.BlissMusic;

class MusicManager {
    /**
	 * Returns a stored music from a specified key.
	 * 
	 * @param key Key for the music (its name).
	 */
	public static inline function get(key:String) {
		return _cache.get(key);
	}

	/**
	 * Returns whether or not a music with a specified key
	 * can be found in the cache.
	 *
	 * @param key The key identifying the music.
	 */
	public static inline function isCached(key:String) {
		return _cache.exists(key);
	}

	/**
	 * Caches any specified music.
	 *
	 * @param	Music to store in the cache.
	 */
	public static inline function cacheMusic(music:BlissMusic):BlissMusic {
		_cache.set(music.key, music);
		return music;
	}

	/**
	 * Destroys each music asset in cache.
	 */
	public static inline function clear() {
		for(asset in _cache)
			asset.destroy();
		_cache.clear();
	}

    @:noCompletion
	private static var _cache:Map<String, BlissMusic> = [];
}