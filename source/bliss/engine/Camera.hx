package bliss.engine;

import bliss.engine.system.Vector2D;

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

	override function render() {
		for(_render in _queuedRenders)
			_render();

		_queuedRenders.clearArray();
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private var _queuedRenders:Array<RenderCallback> = [];
}