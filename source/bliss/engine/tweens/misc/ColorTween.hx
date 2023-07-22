package bliss.engine.tweens.misc;

import bliss.engine.Sprite;
import bliss.engine.tweens.Tween;

import bliss.backend.graphics.BlissColor;

/**
 * Tweens a color's red, green, and blue properties
 * independently. Can also tween an alpha value.
 */
class ColorTween extends Tween {
	public var color(default, null):BlissColor;

	var startColor:BlissColor;
	var endColor:BlissColor;

	/**
	 * Optional sprite object whose color to tween
	 */
	public var sprite(default, null):Sprite;

	/**
	 * Clean up references
	 */
	override public function destroy() {
		super.destroy();
		sprite = null;
	}

	/**
	 * Tweens the color to a new color and an alpha to a new alpha.
	 *
	 * @param	Duration		Duration of the tween.
	 * @param	FromColor		Start color.
	 * @param	ToColor			End color.
	 * @param	Sprite			Optional sprite object whose color to tween.
	 * @return	The ColorTween.
	 */
	public function tween(Duration:Float, FromColor:BlissColor, ToColor:BlissColor, ?Sprite:Sprite):ColorTween {
		color = startColor = FromColor;
		endColor = ToColor;
		duration = Duration;
		sprite = Sprite;
		start();
		return this;
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);
		color = BlissColor.interpolate(startColor, endColor, scale);

		if (sprite != null) {
			sprite.tint = color;
			sprite.alpha = color.alpha / 255;
		}
	}

	override function isTweenOf(object:Dynamic, ?field:String):Bool {
		return sprite == object && (field == null || field == "color");
	}
}
