package bliss.engine;

import bliss.engine.system.Game;
import bliss.engine.system.Vector2D;
import bliss.engine.utilities.MathUtil;

using bliss.engine.utilities.ArrayUtil;

typedef RenderCallback = Void->Void;

class Camera extends Object2D {
	/**
	 * The list of default cameras the game can render.
	 */
	public static var defaultCameras:Array<Camera> = [];

	public var zoom:Vector2D;

	/**
	 * Creates a new Camera instance.
	 */
	public function new() {
		super(0, 0, 0, 0);
		zoom = new Vector2D(1, 1);
	}

    /**
     * Returns if a sprite is on screen.
     * @param sprite The sprite to check.
     */
    public function isOnScreen(sprite:Sprite) {
        return !((sprite.position.x < (-Math.abs((sprite.size.x * sprite.scale.x) * 2) / zoom.x)) ||
            (sprite.position.y < (-Math.abs((sprite.size.y * sprite.scale.y) * 2) / zoom.y)) ||
            (sprite.position.x > ((Game.width + Math.abs((sprite.size.x * sprite.scale.x) * 2)) / zoom.x)) ||
            (sprite.position.y > ((Game.height + Math.abs((sprite.size.y * sprite.scale.y) * 2)) / zoom.y)));
    }

	/**
	 * Adjusts the given position to render properly with the camera's properties.
	 * 
	 * @param position The position to adjust.
	 */
	public function adjustToCamera(position:Vector2D) {
		var radians = (angle % 360) / 180 * MathUtil.FULL_PI;
		var cosMult = Math.cos(radians);
		var sinMult = Math.sin(radians);

		var centerPos = new Vector2D(Game.width * 0.5, Game.height * 0.5);
		
		var newPos = new Vector2D(
			(position.x * zoom.x) - ((Game.width * (1 - zoom.x)) * -0.5) - centerPos.x, 
			(position.y * zoom.y) - ((Game.height * (1 - zoom.y)) * -0.5) - centerPos.y
		);
		newPos.set(
			newPos.x * cosMult + newPos.y * -sinMult,
			newPos.x * sinMult + newPos.y * cosMult
		);
		newPos += centerPos;

		return newPos;
	}

	/**
	 * The function that updates this camera.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	override function update(elapsed:Float) {}

	/**
	 * The function that renders this camera to the screen.
	 */
	override function render() {
		for(_render in _queuedRenders)
			_render();

		_queuedRenders.clearArray();
	}

	/**
	 * Destroys this object.
	 * 
	 * Makes this object potentially unusable afterwards!
	 */
	override function destroy() {
		zoom = null;
		super.destroy();
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private var _queuedRenders:Array<RenderCallback> = [];
}