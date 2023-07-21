package bliss.engine;

import bliss.engine.Camera;
import bliss.engine.system.Vector2D;
import bliss.engine.utilities.MathUtil;
import bliss.backend.graphics.BlissColor;

class Object2D extends Object {
	/**
	 * The position of this object in world space.
	 * 
	 * Starts from the top left.
	 */
	public var position(default, set):Vector2D;

	/**
	 * The width and height of this object.
	 */
	public var size(default, set):Vector2D;

	/**
	 * The color that this object will be tinted to.
	 * 
	 * If this object displays a pure white image
	 * then that white will turn into this color.
	 */
	public var tint(default, set):BlissColor = BlissColor.COLOR_WHITE;

	/**
	 * The transparency that this object will have.
	 * 0 would be invisible, and 1 would be fully visible.
	 */
	public var alpha(default, set):Float = 1.0;

	/**
	 * The rotation of this object (in degrees).
	 */
	public var angle(default, set):Float = 0;

	/**
	 * Creates a new Object2D instance.
	 * 
	 * @param x       The X position of this new object in world space, Starts from the top left.
	 * @param y       The Y position of this new object in world space, Starts from the top left.
	 * 
	 * @param width   The width of this new object.
	 * @param height  The height of this new object.
	 */
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		super();
		position = new Vector2D(x, y);
		size = new Vector2D(width, height);
	}

	/**
	 * Destroys this object.
	 * 
	 * Makes this object potentially unusable afterwards!
	 */
	override function destroy() {
		super.destroy();
		position = null;
		size = null;
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private function get_alpha():Float {
		return alpha;
	}

	@:noCompletion
	private function set_alpha(v:Float) {
		return alpha = MathUtil.bound(v, 0, 1);
	}

	// you might think, why have these getters and setters?
	// it's so you can do something when alpha or position is set or whatever.

	@:noCompletion
	private function set_position(value:Vector2D):Vector2D {
		return position = value;
	}

	@:noCompletion
	private function set_size(value:Vector2D):Vector2D {
		return size = value;
	}

	@:noCompletion
	private function set_tint(value:BlissColor):BlissColor {
		return tint = value;
	}

	@:noCompletion
	private function set_angle(value:Float):Float {
		return angle = value;
	}
}