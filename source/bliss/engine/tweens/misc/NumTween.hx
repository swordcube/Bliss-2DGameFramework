package bliss.engine.tweens.misc;

import bliss.engine.tweens.Tween;

/**
 * Tweens a numeric value. See Tween.num()
 */
class NumTween extends Tween {
	/**
	 * The current value.
	 */
	public var value(default, null):Float;

	// Tween information.
	var _tweenFunction:Float->Void;
	var _start:Float;
	var _range:Float;

	/**
	 * Clean up references
	 */
	override public function destroy():Void {
		super.destroy();
		_tweenFunction = null;
	}

	/**
	 * Tweens the value from one value to another.
	 *
	 * @param	fromValue		Start value.
	 * @param	toValue			End value.
	 * @param	duration		Duration of the tween.
	 * @param	tweenFunction	Optional tween function. See Tween.num()
	 */
	public function tween(fromValue:Float, toValue:Float, duration:Float, ?tweenFunction:Float->Void):NumTween {
		_tweenFunction = tweenFunction;
		_start = value = fromValue;
		_range = toValue - value;
		this.duration = duration;
		start();
		return this;
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);
		value = _start + _range * scale;

		if (_tweenFunction != null)
			_tweenFunction(value);
	}
}
