package bliss.engine;

import bliss.engine.system.Vector2D;
import bliss.backend.graphics.BlissColor;

class Object2D extends Object {
	/**
	 * The position of this object in world space.
	 * 
	 * Starts from the top left.
	 */
	public var position:Vector2D;

	/**
	 * The width and height of this object.
	 */
	public var size:Vector2D;

	/**
	 * Whether or not this object can draw onto the window.
	 */
	public var visible:Bool = true;

	/**
	 * The color that this object will be tinted to.
	 * 
	 * If this object displays a pure white image
	 * then that white will turn into this color.
	 */
	public var tint:BlissColor = BlissColor.COLOR_WHITE;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		super();
		position = new Vector2D(x, y);
		size = new Vector2D(width, height);
	}

	/**
	 * The function that renders this object to the screen.
	 */
	public function render() {}
}