package bliss.engine.tweens;

import bliss.backend.interfaces.IDestroyable;

import bliss.engine.system.Game;
import bliss.engine.system.Vector2D;

import bliss.engine.Object;
import bliss.engine.Sprite;

import bliss.engine.tweens.Ease.EaseFunction;
import bliss.engine.tweens.misc.*;
import bliss.engine.tweens.motion.*;

import bliss.engine.utilities.MathUtil;
import bliss.engine.utilities.ArrayUtil;

import bliss.backend.graphics.BlissColor;

enum abstract TweenType(Int) from Int to Int {
	/**
	 * Persistent Tween type, will stop when it finishes.
	 */
	var PERSIST = 1;

	/**
	 * Looping Tween type, will restart immediately when it finishes.
	 */
	var LOOPING = 2;

	/**
	 * "To and from" Tween type, will play tween hither and thither
	 */
	var PINGPONG = 4;

	/**
	 * Oneshot Tween type, will stop and remove itself from its core container when it finishes.
	 */
	var ONESHOT = 8;

	/**
	 * Backward Tween type, will play tween in reverse direction
	 */
	var BACKWARD = 16;
}

/**
 * Allows you to create smooth interpolations and animations easily. "Tweening" is short
 * for inbetweening: you only have to specify start and end values and `Tween` will
 * generate all values between those two.
 * 
 * @see https://github.com/HaxeFlixel/flixel/blob/master/flixel/tweens/FlxTween.hx
 */
class Tween implements IDestroyable {
	/**
	 * The global tweening manager that handles global tweens
	 */
	public static var globalManager:TweenManager;

	/**
	 * Tweens numeric public properties of an Object. Shorthand for creating a VarTween, starting it and adding it to the TweenManager.
	 *
	 * ```haxe
	 * Tween.tween(Object, { x: 500, y: 350, "scale.x": 2 }, 2.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object		The object containing the properties to tween.
	 * @param	Values		An object containing key/value pairs of properties and target values.
	 * @param	Duration	Duration of the tween in seconds.
	 * @param	Options		A structure with tween options.
	 * @return	The added VarTween object.
	 */
	public static function tween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions):VarTween {
		return globalManager.tween(Object, Values, Duration, Options);
	}

	/**
	 * Tweens some numeric value. Shorthand for creating a NumTween, starting it and adding it to the TweenManager. Using it in
	 * conjunction with a TweenFunction requires more setup, but is faster than VarTween because it doesn't use Reflection.
	 *
	 * ```haxe
	 * function tweenFunction(s:Sprite, v:Float) { s.alpha = v; }
	 * Tween.num(1, 0, 2.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT }, tweenFunction.bind(mySprite));
	 * ```
	 *
	 * Trivia: For historical reasons, you can use either onUpdate or TweenFunction to accomplish the same thing, but TweenFunction
	 * gives you the updated Float as a direct argument.
	 *
	 * @param	FromValue	Start value.
	 * @param	ToValue		End value.
	 * @param	Duration	Duration of the tween.
	 * @param	Options		A structure with tween options.
	 * @param	TweenFunction	A function to be called when the tweened value updates.  It is recommended not to use an anonymous
	 *							function if you are maximizing performance, as those will be compiled to Dynamics on cpp.
	 * @return	The added NumTween object.
	 */
	public static function num(FromValue:Float, ToValue:Float, Duration:Float = 1, ?Options:TweenOptions, ?TweenFunction:Float->Void):NumTween {
		return globalManager.num(FromValue, ToValue, Duration, Options, TweenFunction);
	}

	/**
	 * Tweens numeric value which represents angle. Shorthand for creating a AngleTween object, starting it and adding it to the TweenManager.
	 *
	 * ```haxe
	 * Tween.angle(Sprite, -90, 90, 2.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Sprite		Optional Sprite whose angle should be tweened.
	 * @param	FromAngle	Start angle.
	 * @param	ToAngle		End angle.
	 * @param	Duration	Duration of the tween.
	 * @param	Options		A structure with tween options.
	 * @return	The added AngleTween object.
	 */
	public static function angle(?Sprite:Sprite, FromAngle:Float, ToAngle:Float, Duration:Float = 1, ?Options:TweenOptions):AngleTween {
		return globalManager.angle(Sprite, FromAngle, ToAngle, Duration, Options);
	}

	/**
	 * Tweens numeric value which represents color. Shorthand for creating a ColorTween object, starting it and adding it to a TweenPlugin.
	 *
	 * ```haxe
	 * Tween.color(Sprite, 2.0, 0x000000, 0xffffff, 0.0, 1.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Sprite		Optional Sprite whose color should be tweened.
	 * @param	Duration	Duration of the tween in seconds.
	 * @param	FromColor	Start color.
	 * @param	ToColor		End color.
	 * @param	Options		A structure with tween options.
	 * @return	The added ColorTween object.
	 */
	public static function color(?Sprite:Sprite, Duration:Float = 1, FromColor:BlissColor, ToColor:BlissColor, ?Options:TweenOptions):ColorTween {
		return globalManager.color(Sprite, Duration, FromColor, ToColor, Options);
	}

	/**
	 * Create a new LinearMotion tween.
	 *
	 * ```haxe
	 * Tween.linearMotion(Object, 0, 0, 500, 20, 5, false, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	FromX			X start.
	 * @param	FromY			Y start.
	 * @param	ToX				X finish.
	 * @param	ToY				Y finish.
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return The LinearMotion object.
	 */
	public static function linearMotion(Object:Object2D, FromX:Float, FromY:Float, ToX:Float, ToY:Float, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
			?Options:TweenOptions):LinearMotion {
		return globalManager.linearMotion(Object, FromX, FromY, ToX, ToY, DurationOrSpeed, UseDuration, Options);
	}

	/**
	 * Create a new QuadMotion tween.
	 *
	 * ```haxe
	 * Tween.quadMotion(Object, 0, 100, 300, 500, 100, 2, 5, false, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	FromX			X start.
	 * @param	FromY			Y start.
	 * @param	ControlX		X control, used to determine the curve.
	 * @param	ControlY		Y control, used to determine the curve.
	 * @param	ToX				X finish.
	 * @param	ToY				Y finish.
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return The QuadMotion object.
	 */
	public static function quadMotion(Object:Object2D, FromX:Float, FromY:Float, ControlX:Float, ControlY:Float, ToX:Float, ToY:Float,
			DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:TweenOptions):QuadMotion {
		return globalManager.quadMotion(Object, FromX, FromY, ControlX, ControlY, ToX, ToY, DurationOrSpeed, UseDuration, Options);
	}

	/**
	 * Create a new CubicMotion tween.
	 *
	 * ```haxe
	 * Tween.cubicMotion(_sprite, 0, 0, 500, 100, 400, 200, 100, 100, 2, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object 		The object to move (Object or SpriteGroup)
	 * @param	FromX		X start.
	 * @param	FromY		Y start.
	 * @param	aX			First control x.
	 * @param	aY			First control y.
	 * @param	bX			Second control x.
	 * @param	bY			Second control y.
	 * @param	ToX			X finish.
	 * @param	ToY			Y finish.
	 * @param	Duration	Duration of the movement in seconds.
	 * @param	Options		A structure with tween options.
	 * @return The CubicMotion object.
	 */
	public static function cubicMotion(Object:Object2D, FromX:Float, FromY:Float, aX:Float, aY:Float, bX:Float, bY:Float, ToX:Float, ToY:Float,
			Duration:Float = 1, ?Options:TweenOptions):CubicMotion {
		return globalManager.cubicMotion(Object, FromX, FromY, aX, aY, bX, bY, ToX, ToY, Duration, Options);
	}

	/**
	 * Create a new CircularMotion tween.
	 *
	 * ```haxe
	 * Tween.circularMotion(Object, 250, 250, 50, 0, true, 2, true, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	CenterX			X position of the circle's center.
	 * @param	CenterY			Y position of the circle's center.
	 * @param	Radius			Radius of the circle.
	 * @param	Angle			Starting position on the circle.
	 * @param	Clockwise		If the motion is clockwise.
	 * @param	DurationOrSpeed	Duration of the movement in seconds.
	 * @param	UseDuration		Duration of the movement.
	 * @param	Ease			Optional easer function.
	 * @param	Options			A structure with tween options.
	 * @return The CircularMotion object.
	 */
	public static function circularMotion(Object:Object2D, CenterX:Float, CenterY:Float, Radius:Float, Angle:Float, Clockwise:Bool,
			DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:TweenOptions):CircularMotion {
		return globalManager.circularMotion(Object, CenterX, CenterY, Radius, Angle, Clockwise, DurationOrSpeed, UseDuration, Options);
	}

	/**
	 * Create a new LinearPath tween.
	 *
	 * ```haxe
	 * Tween.linearPath(Object, [Point.get(0, 0), Point.get(100, 100)], 2, true, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object 			The object to move (Object or SpriteGroup)
	 * @param	Points			An array of at least 2 Points defining the path
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return	The LinearPath object.
	 */
	public static function linearPath(Object:Object2D, Points:Array<Vector2D>, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
			?Options:TweenOptions):LinearPath {
		return globalManager.linearPath(Object, Points, DurationOrSpeed, UseDuration, Options);
	}

	/**
	 * Create a new QuadPath tween.
	 *
	 * ```haxe
	 * Tween.quadPath(Object, [Point.get(0, 0), Point.get(200, 200), Point.get(400, 0)], 2, true, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	Points			An array of at least 3 Points defining the path
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return	The QuadPath object.
	 */
	public static function quadPath(Object:Object2D, Points:Array<Vector2D>, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
			?Options:TweenOptions):QuadPath {
		return globalManager.quadPath(Object, Points, DurationOrSpeed, UseDuration, Options);
	}

	/**
	 * Cancels all related tweens on the specified object.
	 *
	 * Note: Any tweens with the specified fields are cancelled, if the tween has other properties they
	 * will also be cancelled.
	 * 
	 * @param Object The object with tweens to cancel.
	 * @param FieldPaths Optional list of the tween field paths to search for. If null or empty, all tweens on the specified
	 * object are canceled. Allows dot paths to check child properties.
	 */
	public static function cancelTweensOf(Object:Dynamic, ?FieldPaths:Array<String>):Void {
		globalManager.cancelTweensOf(Object, FieldPaths);
	}

	/**
	 * Immediately updates all tweens on the specified object with the specified fields that
	 * are not looping (type `Tween.LOOPING` or `Tween.PINGPONG`) and `active` through
	 * their endings, triggering their `onComplete` callbacks.
	 *
	 * Note: if they haven't yet begun, this will first trigger their `onStart` callback.
	 *
	 * Note: their `onComplete` callbacks are triggered in the next frame.
	 * To trigger them immediately, call `Tween.globalManager.update(0);` after this function.
	 *
	 * In no case should it trigger an `onUpdate` callback.
	 *
	 * Note: Any tweens with the specified fields are completed, if the tween has other properties they
	 * will also be completed.
	 *
	 * @param Object The object with tweens to complete.
	 * @param FieldPaths Optional list of the tween field paths to search for. If null or empty, all tweens on
	 * the specified object are completed. Allows dot paths to check child properties.
	 */
	public static function completeTweensOf(Object:Dynamic, ?FieldPaths:Array<String>):Void {
		globalManager.completeTweensOf(Object, FieldPaths);
	}

	/**
	 * The manager to which this tween belongs
	 */
	public var manager:TweenManager;

	public var active(default, set):Bool = false;
	public var duration:Float = 0;
	public var ease:EaseFunction;
	public var onStart:TweenCallback;
	public var onUpdate:TweenCallback;
	public var onComplete:TweenCallback;

	public var type(default, set):TweenType;

	/**
	 * Value between `0` and `1` that indicates how far along this tween is in its completion.
	 * A value of `0.33` means that the tween is `33%` complete.
	 */
	public var percent(get, set):Float;

	public var finished(default, null):Bool;
	public var scale(default, null):Float = 0;
	public var backward(default, null):Bool;

	/**
	 * How many times this tween has been executed / has finished so far - useful to
	 * stop the `LOOPING` and `PINGPONG` types after a certain amount of time
	 */
	public var executions(default, null):Int = 0;

	/**
	 * Seconds to wait until starting this tween, 0 by default
	 */
	public var startDelay(default, set):Float = 0;

	/**
	 * Seconds to wait between loops of this tween, 0 by default
	 */
	public var loopDelay(default, set):Float = 0;

	var _secondsSinceStart:Float = 0;
	var _delayToUse:Float = 0;
	var _running:Bool = false;
	var _waitingForRestart:Bool = false;
	var _chainedTweens:Array<Tween>;
	var _nextTweenInChain:Tween;

	/**
	 * This function is called when tween is created, or recycled.
	 */
	function new(Options:TweenOptions, ?manager:TweenManager):Void {
		Options = resolveTweenOptions(Options);

		type = Options.type;
		onStart = Options.onStart;
		onUpdate = Options.onUpdate;
		onComplete = Options.onComplete;
		ease = Options.ease;
		setDelays(Options.startDelay, Options.loopDelay);
		this.manager = manager != null ? manager : globalManager;
	}

	function resolveTweenOptions(Options:TweenOptions):TweenOptions {
		if (Options == null)
			Options = {type: TweenType.ONESHOT};

		if (Options.type == null)
			Options.type = TweenType.ONESHOT;

		return Options;
	}

	public function destroy():Void {
		onStart = null;
		onUpdate = null;
		onComplete = null;
		ease = null;
		manager = null;
		_chainedTweens = null;
		_nextTweenInChain = null;
	}

	/**
	 * Specify a tween to be executed when this one has finished
	 * (useful for creating "tween chains").
	 */
	public function then(tween:Tween):Tween {
		return addChainedTween(tween);
	}

	/**
	 * How many seconds to delay the execution of the next tween in a tween chain.
	 */
	public function wait(delay:Float):Tween {
		return addChainedTween(Tween.num(0, 0, delay));
	}

	function addChainedTween(tween:Tween):Tween {
		tween.setVarsOnEnd();
		tween.manager.remove(tween, false);

		if (_chainedTweens == null)
			_chainedTweens = [];

		_chainedTweens.push(tween);
		return this;
	}

	function update(elapsed:Float):Void {
		_secondsSinceStart += elapsed;
		var delay:Float = (executions > 0) ? loopDelay : startDelay;
		if (_secondsSinceStart < delay) {
			return;
		}
		scale = Math.max((_secondsSinceStart - delay), 0) / duration;
		if (ease != null) {
			scale = ease(scale);
		}
		if (backward) {
			scale = 1 - scale;
		}
		if (_secondsSinceStart > delay && !_running) {
			_running = true;
			if (onStart != null)
				onStart(this);
		}
		if (_secondsSinceStart >= duration + delay) {
			scale = (backward) ? 0 : 1;
			finished = true;
		} else {
			if (onUpdate != null)
				onUpdate(this);
		}
	}

	/**
	 * Starts the Tween, or restarts it if it's currently running.
	 */
	public function start():Tween {
		_waitingForRestart = false;
		_secondsSinceStart = 0;
		_delayToUse = (executions > 0) ? loopDelay : startDelay;
		if (duration == 0) {
			active = false;
			return this;
		}
		active = true;
		_running = false;
		finished = false;
		return this;
	}

	/**
	 * Immediately stops the Tween and removes it from its
	 * `manager` without calling the `onComplete` callback.
	 *
	 * Yields control to the next chained Tween if one exists.
	 */
	public function cancel():Void {
		onEnd();

		if (manager != null)
			manager.remove(this);
	}

	/**
	 * Immediately stops the Tween and removes it from its
	 * `manager` without calling the `onComplete` callback
	 * or yielding control to the next chained Tween if one exists.
	 *
	 * If control has already been passed on, forwards the cancellation
	 * request along the chain to the currently active Tween.
	 */
	public function cancelChain():Void {
		// Pass along the cancellation request.
		if (_nextTweenInChain != null)
			_nextTweenInChain.cancelChain();

		// Prevent yielding control to any chained tweens.
		if (_chainedTweens != null)
			_chainedTweens = null;

		cancel();
	}

	function finish():Void {
		executions++;

		if (onComplete != null)
			onComplete(this);

		var type = type & ~TweenType.BACKWARD;

		if (type == TweenType.PERSIST || type == TweenType.ONESHOT) {
			onEnd();
			_secondsSinceStart = duration + startDelay;

			if (type == TweenType.ONESHOT && manager != null) {
				manager.remove(this);
			}
		}

		if (type == TweenType.LOOPING || type == TweenType.PINGPONG) {
			_secondsSinceStart = (_secondsSinceStart - _delayToUse) % duration + _delayToUse;
			scale = Math.max((_secondsSinceStart - _delayToUse), 0) / duration;

			if (ease != null && scale > 0 && scale < 1) {
				scale = ease(scale);
			}

			if (type == TweenType.PINGPONG) {
				backward = !backward;
				if (backward) {
					scale = 1 - scale;
				}
			}

			restart();
		}
	}

	/**
	 * Called when the tween ends, either via finish() or cancel().
	 */
	function onEnd():Void {
		setVarsOnEnd();
		processTweenChain();
	}

	function setVarsOnEnd():Void {
		active = false;
		_running = false;
		finished = true;
	}

	function processTweenChain():Void {
		if (_chainedTweens == null || _chainedTweens.length <= 0)
			return;

		// Remember next tween to enable cancellation of the chain.
		_nextTweenInChain = _chainedTweens.shift();

		doNextTween(_nextTweenInChain);
		_chainedTweens = null;
	}

	function doNextTween(tween:Tween):Void {
		if (!tween.active) {
			tween.start();
			manager.add(tween);
		}

		tween.setChain(_chainedTweens);
	}

	function setChain(previousChain:Array<Tween>):Void {
		if (previousChain == null)
			return;

		if (_chainedTweens == null)
			_chainedTweens = previousChain;
		else
			_chainedTweens = _chainedTweens.concat(previousChain);
	}

	/**
	 * In case the tween.active was set to false in onComplete(),
	 * the tween should not be restarted yet.
	 */
	function restart():Void {
		if (active) {
			start();
		} else {
			_waitingForRestart = true;
		}
	}

	/**
	 * Returns true if this is tweening the specified field on the specified object.
	 * 
	 * @param Object The object.
	 * @param Field Optional tween field. Ignored if null.
	 */
	function isTweenOf(Object:Dynamic, ?Field:String):Bool {
		return false;
	}

	/**
	 * Set both type of delays for this tween.
	 *
	 * @param	startDelay	Seconds to wait until starting this tween, 0 by default.
	 * @param	loopDelay	Seconds to wait between loops of this tween, 0 by default.
	 */
	function setDelays(?StartDelay:Null<Float>, ?LoopDelay:Null<Float>):Tween {
		startDelay = (StartDelay != null) ? StartDelay : 0;
		loopDelay = (LoopDelay != null) ? LoopDelay : 0;
		return this;
	}

	function set_startDelay(value:Float):Float {
		var dly:Float = Math.abs(value);
		if (executions == 0) {
			_delayToUse = dly;
		}
		return startDelay = dly;
	}

	function set_loopDelay(value:Null<Float>):Float {
		var dly:Float = Math.abs(value);
		if (executions > 0) {
			_secondsSinceStart = duration * percent + Math.max((dly - loopDelay), 0);
			_delayToUse = dly;
		}
		return loopDelay = dly;
	}

	inline function get_percent():Float {
		return Math.max((_secondsSinceStart - _delayToUse), 0) / duration;
	}

	function set_percent(value:Float):Float {
		return _secondsSinceStart = duration * value + _delayToUse;
	}

	function set_type(value:Int):Int {
		if (value == 0) {
			value = TweenType.ONESHOT;
		} else if (value == TweenType.BACKWARD) {
			value = TweenType.PERSIST | TweenType.BACKWARD;
		}

		backward = (value & TweenType.BACKWARD) > 0;
		return type = value;
	}

	function set_active(active:Bool):Bool {
		this.active = active;

		if (_waitingForRestart)
			restart();

		return active;
	}
}

typedef TweenCallback = Tween->Void;

typedef TweenOptions = {
	/**
	 * Tween type - bit field of `Tween`'s static type constants.
	 */
	@:optional var type:TweenType;

	/**
	 * Optional easer function (see `Ease`).
	 */
	@:optional var ease:EaseFunction;

	/**
	 * Optional start callback function.
	 */
	@:optional var onStart:TweenCallback;

	/**
	 * Optional update callback function.
	 */
	@:optional var onUpdate:TweenCallback;

	/**
	 * Optional complete callback function.
	 */
	@:optional var onComplete:TweenCallback;

	/**
	 * Seconds to wait until starting this tween, `0` by default.
	 */
	@:optional var startDelay:Float;

	/**
	 * Seconds to wait between loops of this tween, `0` by default.
	 */
	@:optional var loopDelay:Float;
}

/**
 * A simple manager for tracking and updating game tween objects.
 * Normally accessed via the static `Tween.globalManager` rather than being created separately.
 */
@:access(bliss.engine.tweens)
@:access(bliss.engine.tweens.Tween)
class TweenManager extends Object {
	/**
	 * A list of all Tween objects.
	 */
	var _tweens(default, null):Array<Tween> = [];

	public function new():Void {
		super();
		Game.signals.preSceneCreate.connect(s_clear);
		Game.signals.preSceneUpdate.connect(s_update);
	}

	/**
	 * Tweens numeric public properties of an Object. Shorthand for creating a VarTween, starting it and adding it to the TweenManager.
	 *
	 * ```haxe
	 * Tween.tween(Object, { x: 500, y: 350, "scale.x": 2 }, 2.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object		The object containing the properties to tween.
	 * @param	Values		An object containing key/value pairs of properties and target values.
	 * @param	Duration	Duration of the tween in seconds.
	 * @param	Options		A structure with tween options.
	 * @return	The added VarTween object.
	 */
	public function tween(Object:Dynamic, Values:Dynamic, Duration:Float = 1, ?Options:TweenOptions):VarTween {
		if (Object == null) {
			trace('Cannot tween an object that is equal to null.');
			return null;
		}

		var tween = new VarTween(Options, this);
		tween.tween(Object, Values, Duration);
		return add(tween);
	}

	/**
	 * Tweens some numeric value. Shorthand for creating a NumTween, starting it and adding it to the TweenManager. Using it in
	 * conjunction with a TweenFunction requires more setup, but is faster than VarTween because it doesn't use Reflection.
	 *
	 * ```haxe
	 * function tweenFunction(s:Sprite, v:Float) { s.alpha = v; }
	 * Tween.num(1, 0, 2.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT }, tweenFunction.bind(mySprite));
	 * ```
	 *
	 * Trivia: For historical reasons, you can use either onUpdate or TweenFunction to accomplish the same thing, but TweenFunction
	 * gives you the updated Float as a direct argument.
	 *
	 * @param	FromValue	Start value.
	 * @param	ToValue		End value.
	 * @param	Duration	Duration of the tween.
	 * @param	Options		A structure with tween options.
	 * @param	TweenFunction	A function to be called when the tweened value updates.  It is recommended not to use an anonymous
	 *							function if you are maximizing performance, as those will be compiled to Dynamics on cpp.
	 * @return	The added NumTween object.
	 */
	public function num(FromValue:Float, ToValue:Float, Duration:Float = 1, ?Options:TweenOptions, ?TweenFunction:Float->Void):NumTween {
		var tween = new NumTween(Options, this);
		tween.tween(FromValue, ToValue, Duration, TweenFunction);
		return add(tween);
	}

	/**
	 * Tweens numeric value which represents angle. Shorthand for creating a AngleTween object, starting it and adding it to the TweenManager.
	 *
	 * ```haxe
	 * Tween.angle(Sprite, -90, 90, 2.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Sprite		Optional Sprite whose angle should be tweened.
	 * @param	FromAngle	Start angle.
	 * @param	ToAngle		End angle.
	 * @param	Duration	Duration of the tween.
	 * @param	Options		A structure with tween options.
	 * @return	The added AngleTween object.
	 */
	public function angle(?Sprite:Sprite, FromAngle:Float, ToAngle:Float, Duration:Float = 1, ?Options:TweenOptions):AngleTween {
		var tween = new AngleTween(Options, this);
		tween.tween(FromAngle, ToAngle, Duration, Sprite);
		return add(tween);
	}

	/**
	 * Tweens numeric value which represents color. Shorthand for creating a ColorTween object, starting it and adding it to a TweenPlugin.
	 *
	 * ```haxe
	 * Tween.color(Sprite, 2.0, 0x000000, 0xffffff, 0.0, 1.0, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Sprite		Optional Sprite whose color should be tweened.
	 * @param	Duration	Duration of the tween in seconds.
	 * @param	FromColor	Start color.
	 * @param	ToColor		End color.
	 * @param	Options		A structure with tween options.
	 * @return	The added ColorTween object.
	 */
	public function color(?Sprite:Sprite, Duration:Float = 1, FromColor:BlissColor, ToColor:BlissColor, ?Options:TweenOptions):ColorTween {
		var tween = new ColorTween(Options, this);
		tween.tween(Duration, FromColor, ToColor, Sprite);
		return add(tween);
	}

	/**
	 * Create a new LinearMotion tween.
	 *
	 * ```haxe
	 * Tween.linearMotion(Object, 0, 0, 500, 20, 5, false, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	FromX			X start.
	 * @param	FromY			Y start.
	 * @param	ToX				X finish.
	 * @param	ToY				Y finish.
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return The LinearMotion object.
	 */
	public function linearMotion(Object:Object2D, FromX:Float, FromY:Float, ToX:Float, ToY:Float, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
			?Options:TweenOptions):LinearMotion {
		var tween = new LinearMotion(Options, this);
		tween.setObject(Object);
		tween.setMotion(FromX, FromY, ToX, ToY, DurationOrSpeed, UseDuration);
		return add(tween);
	}

	/**
	 * Create a new QuadMotion tween.
	 *
	 * ```haxe
	 * Tween.quadMotion(Object, 0, 100, 300, 500, 100, 2, 5, false, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	FromX			X start.
	 * @param	FromY			Y start.
	 * @param	ControlX		X control, used to determine the curve.
	 * @param	ControlY		Y control, used to determine the curve.
	 * @param	ToX				X finish.
	 * @param	ToY				Y finish.
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return The QuadMotion object.
	 */
	public function quadMotion(Object:Object2D, FromX:Float, FromY:Float, ControlX:Float, ControlY:Float, ToX:Float, ToY:Float, DurationOrSpeed:Float = 1,
			UseDuration:Bool = true, ?Options:TweenOptions):QuadMotion {
		var tween = new QuadMotion(Options, this);
		tween.setObject(Object);
		tween.setMotion(FromX, FromY, ControlX, ControlY, ToX, ToY, DurationOrSpeed, UseDuration);
		return add(tween);
	}

	/**
	 * Create a new CubicMotion tween.
	 *
	 * ```haxe
	 * Tween.cubicMotion(_sprite, 0, 0, 500, 100, 400, 200, 100, 100, 2, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object 		The object to move (Object or SpriteGroup)
	 * @param	FromX		X start.
	 * @param	FromY		Y start.
	 * @param	aX			First control x.
	 * @param	aY			First control y.
	 * @param	bX			Second control x.
	 * @param	bY			Second control y.
	 * @param	ToX			X finish.
	 * @param	ToY			Y finish.
	 * @param	Duration	Duration of the movement in seconds.
	 * @param	Options		A structure with tween options.
	 * @return The CubicMotion object.
	 */
	public function cubicMotion(Object:Object2D, FromX:Float, FromY:Float, aX:Float, aY:Float, bX:Float, bY:Float, ToX:Float, ToY:Float, Duration:Float = 1,
			?Options:TweenOptions):CubicMotion {
		var tween = new CubicMotion(Options, this);
		tween.setObject(Object);
		tween.setMotion(FromX, FromY, aX, aY, bX, bY, ToX, ToY, Duration);
		return add(tween);
	}

	/**
	 * Create a new CircularMotion tween.
	 *
	 * ```haxe
	 * Tween.circularMotion(Object, 250, 250, 50, 0, true, 2, true, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	CenterX			X position of the circle's center.
	 * @param	CenterY			Y position of the circle's center.
	 * @param	Radius			Radius of the circle.
	 * @param	Angle			Starting position on the circle.
	 * @param	Clockwise		If the motion is clockwise.
	 * @param	DurationOrSpeed	Duration of the movement in seconds.
	 * @param	UseDuration		Duration of the movement.
	 * @param	Ease			Optional easer function.
	 * @param	Options			A structure with tween options.
	 * @return The CircularMotion object.
	 */
	public function circularMotion(Object:Object2D, CenterX:Float, CenterY:Float, Radius:Float, Angle:Float, Clockwise:Bool, DurationOrSpeed:Float = 1,
			UseDuration:Bool = true, ?Options:TweenOptions):CircularMotion {
		var tween = new CircularMotion(Options, this);
		tween.setObject(Object);
		tween.setMotion(CenterX, CenterY, Radius, Angle, Clockwise, DurationOrSpeed, UseDuration);
		return add(tween);
	}

	/**
	 * Create a new LinearPath tween.
	 *
	 * ```haxe
	 * Tween.linearPath(Object, [Point.get(0, 0), Point.get(100, 100)], 2, true, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object 			The object to move (Object or SpriteGroup)
	 * @param	Points			An array of at least 2 Points defining the path
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return	The LinearPath object.
	 */
	public function linearPath(Object:Object2D, Points:Array<Vector2D>, DurationOrSpeed:Float = 1, UseDuration:Bool = true,
			?Options:TweenOptions):LinearPath {
		var tween = new LinearPath(Options, this);

		if (Points != null) {
			for (point in Points) {
				tween.addPoint(point.x, point.y);
			}
		}

		tween.setObject(Object);
		tween.setMotion(DurationOrSpeed, UseDuration);
		return add(tween);
	}

	/**
	 * Create a new QuadPath tween.
	 *
	 * ```haxe
	 * Tween.quadPath(Object, [Point.get(0, 0), Point.get(200, 200), Point.get(400, 0)], 2, true, { ease: easeFunction, onStart: onStart, onUpdate: onUpdate, onComplete: onComplete, type: ONESHOT });
	 * ```
	 *
	 * @param	Object			The object to move (Object or SpriteGroup)
	 * @param	Points			An array of at least 3 Points defining the path
	 * @param	DurationOrSpeed	Duration (in seconds) or speed of the movement.
	 * @param	UseDuration		Whether to use the previous param as duration or speed.
	 * @param	Options			A structure with tween options.
	 * @return	The QuadPath object.
	 */
	public function quadPath(Object:Object2D, Points:Array<Vector2D>, DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:TweenOptions):QuadPath {
		var tween = new QuadPath(Options, this);

		if (Points != null) {
			for (point in Points) {
				tween.addPoint(point.x, point.y);
			}
		}

		tween.setObject(Object);
		tween.setMotion(DurationOrSpeed, UseDuration);
		return add(tween);
	}

	override public function destroy():Void {
		super.destroy();
		Game.signals.preSceneCreate.disconnect(s_clear);
		Game.signals.preSceneUpdate.disconnect(s_update);
	}

	override public function update(elapsed:Float):Void {
		// process finished tweens after iterating through main list, since finish() can manipulate Tween.list
		var finishedTweens:Array<Tween> = null;

		for (tween in _tweens) {
			if (!tween.active)
				continue;

			tween.update(elapsed);
			if (tween.finished) {
				if (finishedTweens == null)
					finishedTweens = [];
				finishedTweens.push(tween);
			}
		}

		if (finishedTweens != null) {
			while (finishedTweens.length > 0) {
				finishedTweens.shift().finish();
			}
		}
	}

	/**
	 * Add a Tween.
	 *
	 * @param	Tween	The Tween to add.
	 * @param	Start	Whether you want it to start right away.
	 * @return	The added Tween object.
	 */
	@:generic
	@:allow(bliss.engine.tweens.Tween)
	function add<T:Tween>(Tween:T, Start:Bool = false):T {
		// Don't add a null object
		if (Tween == null)
			return null;

		_tweens.push(Tween);

		if (Start)
			Tween.start();
		return Tween;
	}

	/**
	 * Remove a Tween.
	 *
	 * @param	Tween		The Tween to remove.
	 * @param	Destroy		Whether you want to destroy the Tween
	 * @return	The removed Tween object.
	 */
	@:allow(bliss.engine.tweens.Tween)
	function remove(Tween:Tween, Destroy:Bool = true):Tween {
		if (Tween == null)
			return null;

		Tween.active = false;

		if (Destroy)
			Tween.destroy();

		ArrayUtil.fastSplice(_tweens, Tween);

		return Tween;
	}

	/**
	 * Removes all Tweens.
	 */
	public function clear():Void {
		for (tween in _tweens) {
			if (tween != null) {
				tween.active = false;
				tween.destroy();
			}
		}

		_tweens.splice(0, _tweens.length);
	}

	/**
	 * Cancels all related tweens on the specified object.
	 *
	 * Note: Any tweens with the specified fields are cancelled, if the tween has other properties they
	 * will also be cancelled.
	 * 
	 * @param Object The object with tweens to cancel.
	 * @param FieldPaths Optional list of the tween field paths to search for. If null or empty, all tweens on the specified
	 * object are canceled. Allows dot paths to check child properties.
	 */
	public function cancelTweensOf(Object:Dynamic, ?FieldPaths:Array<String>):Void {
		forEachTweensOf(Object, FieldPaths, function(tween) tween.cancel());
	}

	/**
	 * Immediately updates all tweens on the specified object with the specified fields that
	 * are not looping (type `Tween.LOOPING` or `Tween.PINGPONG`) and `active` through
	 * their endings, triggering their `onComplete` callbacks.
	 *
	 * Note: if they haven't yet begun, this will first trigger their `onStart` callback.
	 *
	 * Note: their `onComplete` callbacks are triggered in the next frame.
	 * To trigger them immediately, call `Tween.globalManager.update(0);` after this function.
	 *
	 * In no case should it trigger an `onUpdate` callback.
	 *
	 * Note: Any tweens with the specified fields are completed, if the tween has other properties they
	 * will also be completed.
	 *
	 * @param Object The object with tweens to complete.
	 * @param FieldPaths Optional list of the tween field paths to search for. If null or empty, all tweens on
	 * the specified object are completed. Allows dot paths to check child properties.
	 */
	public function completeTweensOf(Object:Dynamic, ?FieldPaths:Array<String>):Void {
		forEachTweensOf(Object, FieldPaths, function(tween) {
			if ((tween.type & TweenType.LOOPING) == 0 && (tween.type & TweenType.PINGPONG) == 0 && tween.active)
				tween.update(MathUtil.MAX_VALUE_FLOAT);
		});
	}

	/**
	 * Internal helper for iterating tweens with specific parameters.
	 *
	 * Note: loops backwards to allow removals.
	 *
	 * @param Object The object with tweens you are searching for.
	 * @param FieldPaths Optional list of the tween field paths to check. If null or empty, any tween of the specified
	 * object will match. Allows dot paths to check child properties.
	 * @param Function The function to call on each matching tween.
	 */
	function forEachTweensOf(Object:Dynamic, ?FieldPaths:Array<String>, Function:Tween->Void) {
		if (Object == null) {
			trace("Cannot cancel tween variables of an object that is null.");
            return;
        }

		if (FieldPaths == null || FieldPaths.length == 0) {
			var i = _tweens.length;
			while (i-- > 0) {
				var tween = _tweens[i];
				if (tween.isTweenOf(Object))
					Function(tween);
			}
		} else {
			// check for dot paths and convert to object/field pairs
			var propertyInfos = new Array<TweenProperty>();
			for (fieldPath in FieldPaths) {
				var target = Object;
				var path = fieldPath.split(".");
				var field = path.pop();
				for (component in path) {
					target = Reflect.getProperty(target, component);
					if (!Reflect.isObject(target))
						break;
				}

				if (Reflect.isObject(target))
					propertyInfos.push({object: target, field: field});
			}

			var i = _tweens.length;
			while (i-- > 0) {
				var tween = _tweens[i];
				for (info in propertyInfos) {
					if (tween.isTweenOf(info.object, info.field)) {
						Function(tween);
						break;
					}
				}
			}
		}
	}

	function s_clear(_) {
		clear();
	}

	function s_update(_) {
		update(Game.elapsed);
	}

	/**
	 * Immediately updates all tweens that are not looping (type `Tween.LOOPING` or `Tween.PINGPONG`)
	 * and `active` through their endings, triggering their `onComplete` callbacks.
	 *
	 * Note: if they haven't yet begun, this will first trigger their `onStart` callback.
	 *
	 * Note: their `onComplete` callbacks are triggered in the next frame.
	 * To trigger them immediately, call `Tween.globalManager.update(0);` after this function.
	 *
	 * In no case should it trigger an `onUpdate` callback.
	 */
	public function completeAll():Void {
		for (tween in _tweens)
			if ((tween.type & TweenType.LOOPING) == 0 && (tween.type & TweenType.PINGPONG) == 0 && tween.active)
				tween.update(MathUtil.MAX_VALUE_FLOAT);
	}

	/**
	 * Applies a function to all tweens
	 *
	 * @param   Function   A function that modifies one tween at a time
	 */
	public function forEach(Function:Tween->Void) {
		for (tween in _tweens)
			Function(tween);
	}
}

private typedef TweenProperty = {
	object:Dynamic,
	field:String
}
