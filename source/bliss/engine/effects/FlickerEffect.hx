package bliss.engine.effects;

import bliss.engine.utilities.BlissTimer;
import bliss.engine.system.Game;
import bliss.backend.interfaces.IDestroyable;

/**
 * The retro flickering effect with callbacks.
 * You can use this as a mixin in any Object subclass or by calling the static functions.
 * 
 * @see https://github.com/HaxeFlixel/flixel/blob/master/flixel/effects/FlxFlicker.hx
 * @author pixelomatic
 */
class FlickerEffect implements IDestroyable {
	/**
	 * Internal map for looking up which objects are currently flickering and getting their flicker data.
	 */
	static var _boundObjects:Map<Object, FlickerEffect> = new Map<Object, FlickerEffect>();

	/**
	 * A simple flicker effect for sprites using a ping-pong tween by toggling visibility.
	 *
	 * @param   Object               The object.
	 * @param   duration             How long to flicker for (in seconds). `0` means "forever".
	 * @param   interval             In what interval to toggle visibility. Set to `Game.elapsed` if `<= 0`!
	 * @param   endVisibility        Force the visible value when the flicker completes,
	 *                               useful with fast repetitive use.
	 * @param   forceRestart         Force the flicker to restart from beginning,
	 *                               discarding the flickering effect already in progress if there is one.
	 * @param   completionCallback   An optional callback that will be triggered when a flickering has finished.
	 * @param   progressCallback     An optional callback that will be triggered when visibility is toggled.
     * 
	 * @return The `FlickerEffect` object.
	 */
	public static function flicker(object:Object, duration:Float = 1, interval:Float = 0.04, endVisibility:Bool = true, forceRestart:Bool = true,
			?completionCallback:FlickerEffect->Void, ?progressCallback:FlickerEffect->Void):FlickerEffect {
		if (isFlickering(object)) {
			if (forceRestart) {
				stopFlickering(object);
			} else {
				// Ignore this call if object is already flickering.
				return _boundObjects[object];
			}
		}

		if (interval <= 0)
			interval = Game.elapsed;

		var flicker:FlickerEffect = new FlickerEffect();
		flicker.start(object, duration, interval, endVisibility, completionCallback, progressCallback);
		return _boundObjects[object] = flicker;
	}

	/**
	 * Returns whether the object is flickering or not.
	 *
	 * @param   Object The object to test.
	 */
	public static function isFlickering(Object:Object):Bool {
		return _boundObjects.exists(Object);
	}

	/**
	 * Stops flickering of the object. Also it will make the object visible.
	 *
	 * @param   Object The object to stop flickering.
	 */
	public static function stopFlickering(Object:Object):Void {
		var boundFlicker:FlickerEffect = _boundObjects[Object];
		if (boundFlicker != null) {
			boundFlicker.stop();
		}
	}

	/**
	 * The flickering object.
	 */
	public var object(default, null):Object;

	/**
	 * The final visibility of the object after flicker is complete.
	 */
	public var endVisibility(default, null):Bool;

	/**
	 * The flicker timer. You can check how many seconds has passed since flickering started etc.
	 */
	public var timer(default, null):BlissTimer;

	/**
	 * The callback that will be triggered after flicker has completed.
	 */
	public var completionCallback(default, null):FlickerEffect->Void;

	/**
	 * The callback that will be triggered every time object visiblity is changed.
	 */
	public var progressCallback(default, null):FlickerEffect->Void;

	/**
	 * The duration of the flicker (in seconds). `0` means "forever".
	 */
	public var duration(default, null):Float;

	/**
	 * The interval of the flicker.
	 */
	public var interval(default, null):Float;

	/**
	 * Nullifies the references to prepare object for reuse and avoid memory leaks.
	 */
	public function destroy():Void {
		object = null;
		timer = null;
		completionCallback = null;
		progressCallback = null;
	}

	/**
	 * Starts flickering behavior.
	 */
    @:noCompletion
    private function start(object:Object, duration:Float, interval:Float, endVisibility:Bool, ?completionCallback:FlickerEffect->Void, ?progressCallback:FlickerEffect->Void):Void {
		this.object = object;
		this.duration = duration;
		this.interval = interval;
		this.completionCallback = completionCallback;
		this.progressCallback = progressCallback;
		this.endVisibility = endVisibility;
		timer = new BlissTimer().start(interval, flickerProgress, Std.int(duration / interval));
	}

	/**
	 * Prematurely ends flickering.
	 */
	public function stop():Void {
		timer.stop();
		object.visible = true;
		release();
	}

	/**
	 * Unbinds the object from flicker.
	 */
    @:noCompletion
    private function release():Void {
		_boundObjects.remove(object);
	}

	/**
	 * Just a helper function for flicker() to update object's visibility.
	 */
	@:noCompletion
    private function flickerProgress(Timer:BlissTimer):Void {
		object.visible = !object.visible;

		if (progressCallback != null)
			progressCallback(this);

		if (Timer.loops > 0 && Timer.loopsLeft == 0) {
			object.visible = endVisibility;
			if (completionCallback != null)
				completionCallback(this);
			
			release();
		}
	}

	/**
	 * Internal constructor. Use static methods.
	 */
	@:keep
	function new() {}
}
