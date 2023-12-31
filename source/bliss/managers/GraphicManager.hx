package bliss.managers;

import bliss.backend.graphics.BlissGraphic;

class GraphicManager {
	/**
	 * Returns a stored graphic from a specified key.
	 * 
	 * @param key Key for the graphic (its name).
	 */
	public inline function get(key:String) {
		return _cache.get(key);
	}

	/**
	 * Returns whether or not a graphic with a specified key
	 * can be found in the cache.
	 *
	 * @param key The key identifying the graphic.
	 */
	public inline function isCached(key:String) {
		return _cache.exists(key);
	}

	/**
	 * Caches any specified graphic.
	 *
	 * @param	Graphic to store in the cache.
	 */
	public inline function cacheGraphic(graphic:BlissGraphic):BlissGraphic {
		_cache.set(graphic.key, graphic);
		return graphic;
	}

	/**
	 * Destroys each graphic in cache.
	 */
	public inline function clear() {
		for(graphic in _cache)
			graphic.destroy();
		_cache.clear();
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	public function new() {}

	@:noCompletion
	private var _cache:Map<String, BlissGraphic> = [];
}