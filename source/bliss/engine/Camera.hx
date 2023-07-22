package bliss.engine;

import bliss.backend.graphics.BlissColor;

import bliss.engine.system.Game;
import bliss.engine.system.Vector2D;

import bliss.engine.utilities.Axes;
import bliss.engine.utilities.MathUtil;

using bliss.engine.utilities.ArrayUtil;

typedef RenderCallback = Void->Void;

class Camera extends Object2D {
	/**
	 * The list of default cameras the game can render.
	 */
	public static var defaultCameras:Array<Camera> = [];

	/**
	 * An offset to the X & Y position of this camera.
	 * 
	 * Used for camera shaking.
	 */
	public var offset:Vector2D;

	/**
	 * The initial zoom multiplier of this camera.
	 */
	public var initialZoom:Vector2D;

	/**
	 * The current zoom multiplier of this camera.
	 */
	public var zoom:Vector2D;

	/**
	 * Used to smoothly track the camera as it follows:
	 * The percent of the distance to the follow `target` the camera moves per 1/60 sec.
	 * 
	 * The maximum value means no camera easing. A value of `0` means the camera does not move.
	 */
	public var followLerp(default, set):Float = 1;

	 /**
	  * Whenever target following is enabled. Defaults to `true`.
	  */
	public var followEnabled:Bool = true;

	/**
	 * The target that this camera is currently following.
	 */
	public var target:Object2D = null;

	/**
	 * Stores the basic parallax scrolling values.
	 * This is basically the camera's top-left corner position in world coordinates.
	 */
	public var scroll:Vector2D;

	/**
	 * Creates a new Camera instance.
	 */
	public function new() {
		super(0, 0, 0, 0);
	}

	override function initVars() {
		initialZoom = zoom = new Vector2D(1, 1);
		offset = new Vector2D(0, 0);
		scroll = new Vector2D(0, 0);
	}

	/**
	 * The screen is filled with this color and gradually returns to normal.
	 *
	 * @param   color        The color you want to use.
	 * @param   duration     How long it takes for the flash to fade.
	 * @param   onComplete   A function you want to run when the flash finishes.
	 * @param   force        Force the effect to reset.
	 */
	public function flash(color:BlissColor = BlissColor.COLOR_WHITE, duration:Float = 1, ?onComplete:Void->Void, force:Bool = false) {
		if(!force && _fxFlashAlpha > 0)
			return;

		_fxFlashColor = color;
		if(duration <= 0.001)
			duration = 0.001;
		_fxFlashDuration = duration;
		_fxFlashOnComplete = onComplete;
		_fxFlashAlpha = 1;
	}

	/**
	 * The screen is gradually filled with this color.
	 *
	 * @param   color        The color you want to use.
	 * @param   duration     How long it takes for the fade to finish.
	 * @param   fadeIn       `true` fades from a color, `false` fades to it.
	 * @param   onComplete   A function you want to run when the fade finishes.
	 * @param   force        Force the effect to reset.
	 */
	public function fade(color:BlissColor = BlissColor.COLOR_BLACK, duration:Float = 1, fadeIn:Bool = false, ?onComplete:Void->Void, force:Bool = false) {
		if (!force && _fxFadeDuration > 0)
			return;

		_fxFadeColor = color;
		if(duration <= 0.001)
			duration = 0.001;

		_fxFadeIn = fadeIn;
		_fxFadeDuration = duration;
		_fxFadeOnComplete = onComplete;

		_fxFadeAlpha = _fxFadeIn ? 0.999999 : 0.000001;
	}

	/**
	 * A simple screen-shake effect.
	 *
	 * @param   intensity    Percentage of screen size representing the maximum distance
	 *                       that the screen can move while shaking.
	 * @param   duration     The length in seconds that the shaking effect should last.
	 * @param   onComplete   A function you want to run when the shake effect finishes.
	 * @param   force        Force the effect to reset (default = `true`, unlike `flash()` and `fade()`!).
	 * @param   axes         On what axes to shake. Default value is `Axes.XY` / both.
	 */
	public function shake(intensity:Float = 0.05, duration:Float = 0.5, ?onComplete:Void->Void, force:Bool = true, ?axes:Axes):Void {
		if(axes == null)
			axes = XY;

		if(!force && _fxShakeDuration > 0)
			return;

		_fxShakeIntensity = intensity;
		_fxShakeDuration = duration;
		_fxShakeOnComplete = onComplete;
		_fxShakeAxes = axes;
	}

	/**
	 * Tells this camera object what `Object` to track.
	 *
	 * @param   target   The object you want the camera to track. Set to `null` to not follow anything.
	 * @param   lerp     How much lag the camera should have (can help smooth out the camera movement).
	 */
	public function follow(target:Object2D, ?lerp:Float) {
		if(lerp == null)
			lerp = 1;

		this.target = target;
		this.followLerp = lerp;
	}

	/**
	 * Snaps this camera to the target instantly.
	 */
	public function snapToTarget() {
		scroll.set(
			(target.position.x - Game.width) * 0.5,
			(target.position.y - Game.height) * 0.5
		);
	}

	/**
	 * Stops every camera effect at once.
	 */
	public function stopFX() {
		_fxFlashAlpha = 0;
		_fxFadeAlpha = 0;
		_fxFadeDuration = 0;
		_fxShakeDuration = 0;
	}

	/**
	 * The function that updates this camera.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	override function update(elapsed:Float) {
		updateFollow(elapsed);
		updateFlashFX(elapsed);
		updateFadeFX(elapsed);
		updateShakeFX(elapsed);
	}

	/**
	 * The function that renders this camera to the screen.
	 */
	override function render() {
		for(_render in _queuedRenders)
			_render();

		_queuedRenders.clearArray();

		renderFX();
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

	// flash fx
	@:noCompletion
	private var _fxFlashColor:BlissColor;

	@:noCompletion
	private var _fxFlashDuration:Float;

	@:noCompletion
	private var _fxFlashAlpha:Float;

	@:noCompletion
	private var _fxFlashOnComplete:Void->Void;

	// fade fx
	@:noCompletion
	private var _fxFadeColor:BlissColor;

	@:noCompletion
	private var _fxFadeDuration:Float;

	@:noCompletion
	private var _fxFadeIn:Bool;

	@:noCompletion
	private var _fxFadeAlpha:Float;

	@:noCompletion
	private var _fxFadeOnComplete:Void->Void;

	// shake fx
	@:noCompletion
	private var _fxShakeIntensity:Float;

	@:noCompletion
	private var _fxShakeDuration:Float;

	@:noCompletion
	private var _fxShakeOnComplete:Void->Void;

	@:noCompletion
	private var _fxShakeAxes:Axes;

	@:noCompletion
	private function set_followLerp(value:Float) {
		return followLerp = MathUtil.bound(value, 0, 1);
	}

	@:noCompletion
	private function updateFollow(elapsed:Float) {
		if(!followEnabled || target == null) return;

		final lerpSpeed:Float = MathUtil.bound(followLerp * 60 * elapsed, 0, 1);

		if(followLerp >= 1 || lerpSpeed >= 1)
			snapToTarget();
		else {
			scroll.x = MathUtil.lerp(scroll.x, (target.position.x - Game.width) * 0.5, lerpSpeed);
			scroll.y = MathUtil.lerp(scroll.y, (target.position.y - Game.height) * 0.5, lerpSpeed);
		}
	}

	@:noCompletion
	private function completeFade() {
		_fxFadeDuration = 0;
		if (_fxFadeOnComplete != null)
			_fxFadeOnComplete();
	}

	@:noCompletion
	private function completeShake() {
		offset.set(0, 0);
		if(_fxShakeOnComplete != null)
			_fxShakeOnComplete();
	}

	@:noCompletion
	private function renderFX() {
		// render flash fx
		if(_fxFlashAlpha > 0) {
			var color:Rl.Color = _fxFlashColor.toRaylib();
			color.a = Std.int(_fxFlashAlpha * 255);
			Rl.drawRectangle(
				0, 0, 
				Game.width, Game.height,
				color
			);
		}

		// render fade fx
		if(_fxFadeAlpha > 0) {
			var color:Rl.Color = _fxFadeColor.toRaylib();
			color.a = Std.int(_fxFadeAlpha * 255);
			Rl.drawRectangle(
				0, 0, 
				Game.width, Game.height,
				color
			);
		}
	}

	@:noCompletion
	private function updateFlashFX(elapsed:Float) {
		if(_fxFlashAlpha <= 0) return;
		_fxFlashAlpha -= elapsed / _fxFlashDuration;
		if(_fxFlashAlpha <= 0 && _fxFlashOnComplete != null)
			_fxFlashOnComplete();
	}

	@:noCompletion
	private function updateFadeFX(elapsed:Float) {
		if(_fxFadeAlpha <= 0) return;
		
		if(_fxFadeIn) {
			_fxFadeAlpha -= elapsed / _fxFadeDuration;
			if(_fxFadeAlpha <= 0) {
				_fxFadeAlpha = 0;
				completeFade();
			}
		} else {
			_fxFadeAlpha += elapsed / _fxFadeDuration;
			if(_fxFadeAlpha >= 1.0) {
				_fxFadeAlpha = 1.0;
				completeFade();
			}
		}
	}

	@:noCompletion
	private function updateShakeFX(elapsed:Float) {
		if(_fxShakeDuration > 0) {
			_fxShakeDuration -= elapsed;
			if (_fxShakeDuration <= 0)
				completeShake();
			else {
				if(_fxShakeAxes.x)
					offset.x = Game.random.float(-_fxShakeIntensity * Game.width, _fxShakeIntensity * Game.width) * zoom.x;
				
				if(_fxShakeAxes.y)
					offset.y = Game.random.float(-_fxShakeIntensity * Game.height, _fxShakeIntensity * Game.height) * zoom.y;
			}
		}
	}

	/**
     * Returns if a sprite is on screen.
	 * 
     * @param sprite  The sprite to check.
     */
	@:noCompletion
	private function isOnScreen(sprite:Sprite) {
		final leftOff:Bool = (sprite.position.x < (-Math.abs((sprite.size.x * sprite.scale.x) * 2) / zoom.x));
		final rightOff:Bool = (sprite.position.x > ((Game.width + Math.abs((sprite.size.x * sprite.scale.x) * 2)) / zoom.x));
		final topOff:Bool = (sprite.position.y < (-Math.abs((sprite.size.y * sprite.scale.y) * 2) / zoom.y));
		final bottomOff:Bool = (sprite.position.y > ((Game.height + Math.abs((sprite.size.y * sprite.scale.y) * 2)) / zoom.y));
		
        return !(leftOff || rightOff || topOff || bottomOff);
    }

	/**
	 * Adjusts the given position to render properly with the camera's properties.
	 * 
	 * @param position  The position to adjust.
	 */
	@:noCompletion
	private function adjustToCamera(position:Vector2D) {
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
		newPos += this.position;
		newPos += offset;

		return newPos;
	}
}