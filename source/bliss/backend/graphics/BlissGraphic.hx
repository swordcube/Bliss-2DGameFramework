package bliss.backend.graphics;

import bliss.engine.system.Game;
import bliss.engine.utilities.typeLimit.*;

import bliss.backend.interfaces.IDestroyable;

typedef BlissGraphicAsset = OneOfTwo<String, BlissGraphic>;

class BlissGraphic implements IDestroyable {
	/**
	 * Whether or not this graphic should stay in memory
	 * unless forcefully cleared with the `destroy()` function.
	 */
	public var persist:Bool = false;

	/**
	 * The width of this graphic in pixels.
	 */
	public var width(get, never):Int;

	/**
	 * The height of this graphic in pixels.
	 */
	public var height(get, never):Int;

	/**
	 * The key/name of this graphic.
	 */
	public var key:String;

	/**
	 * The amount of times this graphic has been used.
	 */
	public var useCount(default, set):Int = 0;

	/**
	 * Returns a graphic from an asset path.
	 * 
	 * @param path  The path to load from. Example: assets/haxe.png
	 * @param key   The key of an already stored graphic to try and load.
	 */
	public static function fromFile(path:String, ?key:String):BlissGraphic {
		if(key == null) key = path;

		@:privateAccess
		if(Game.graphic.isCached(key))
			return Game.graphic.get(key);
		else {
			var graphic:BlissGraphic = new BlissGraphic();
			graphic.texture = Rl.loadTexture(path);
			graphic.key = key;
			return Game.graphic.cacheGraphic(graphic);
		}
	}

	/**
	 * Destroys this graphic, making it potentially
	 * unusable afterwards!
	 */
	public function destroy() {
		Rl.unloadTexture(texture);
		texture = null;
		useCount = -1;
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	/**
	 * Used internally, please use the static helper functions.
	 */
	@:noCompletion
	private function new() {}

	@:noCompletion
	private var texture:Rl.Texture2D;

	@:noCompletion
	private inline function set_useCount(v:Int) {
		if(v < 1 && !persist && texture != null)
			destroy();
		
		return useCount = v;
	}

	@:noCompletion
	private inline function get_width():Int {
		return texture.width;
	}

	@:noCompletion
	private inline function get_height():Int {
		return texture.width;
	}
}