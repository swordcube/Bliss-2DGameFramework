package bliss.engine;

import bliss.backend.graphics.BlissGraphic;

class Sprite extends Object2D {
	/**
	 * The graphic that this sprite renders.
	 */
	public var graphic:BlissGraphic;

	/**
	 * Creates a new Sprite instance.
	 * 
	 * @param x The X position of this new object in world space, Starts from the top left.
	 * @param y The Y position of this new object in world space, Starts from the top left.
	 */
	public function new(x:Float = 0, y:Float = 0) {
		super(x, y, 0, 0);
	}

	/**
	 * Makes the sprite start rendering any specified graphic.
	 * 
	 * @param graphic The graphic to load.
	 */
	public function loadGraphic(graphic:BlissGraphicAsset) {
		return this;
	}

	override function update(elapsed:Float) {
		trace("i am the sprite");
	}
}