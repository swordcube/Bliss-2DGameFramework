package bliss.managers;

import bliss.backend.interfaces.IDestroyable;

class CacheManager {
	/**
	 * Returns a stored asset from a specified key.
	 * 
	 * @param key  Key for the asset (its name).
	 */
	public inline function get(key:String) {
		return _cache.get(key);
	}

	/**
	 * Returns if a specified key exists.
	 * 
	 * @param key  The key to check.
	 */
	 public inline function exists(key:String) {
		return _cache.exists(key);
	}

	/**
	 * Returns whether or not a asset with a specified key
	 * can be found in the cache.
	 *
	 * @param key  The key identifying the asset.
	 */
	public inline function isCached(key:String) {
		return _cache.exists(key);
	}

	/**
	 * Caches any specified asset.
	 *
	 * @param key    The name of the asset.
	 * @param asset  Asset to store in the cache.
	 */
	public inline function cacheAsset(key:String, asset:IDestroyable):IDestroyable {
		_cache.set(key, asset);
		return asset;
	}

	/**
	 * Destroys each graphic in cache.
	 */
	public inline function clear() {
		for(asset in _cache)
			asset.destroy();
		_cache.clear();
	}

	@:noCompletion
	private var _cache:Map<String, IDestroyable> = [];

	@:noCompletion
	public function new() {}
}
