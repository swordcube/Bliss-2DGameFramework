package bliss.engine;

import bliss.backend.graphics.BlissColor;

import bliss.engine.system.Game;
import bliss.engine.system.Vector2D;

import bliss.engine.utilities.Axes;

class SpriteGroup<T:Sprite> extends Group<T> {
	/**
	 * The position of this group in world space.
	 * 
	 * Starts from the top left.
	 */
	public var position:Vector2D;

	/**
	 * The width and height of this group.
	 */
	public var size(get, null):Vector2D;

    /**
	 * The color that this object will be tinted to.
	 * 
	 * If this object displays a pure white image
	 * then that white will turn into this color.
	 */
	public var tint(default, set):BlissColor = BlissColor.COLOR_WHITE;

    public function new(x:Float = 0, y:Float = 0) {
        super();
        position = new Vector2D(x, y);
        size = new Vector2D(1, 1);
    }

    /**
	 * Sets the position of the group to the center of the screen.
	 */
     public inline function screenCenter(axes:Axes = XY) {
		if(axes.x)
			position.x = (Game.width - size.x) * 0.5;

		if(axes.y)
			position.y = (Game.height - size.y) * 0.5;
	}

	/**
	 * Returns the left-most position of the left-most member.
	 * If there are no members, x is returned.
	 */
	public function findMinX() {
		return length == 0 ? position.x : findMinXHelper();
	}

	/**
	 * Returns the right-most position of the right-most member.
	 * If there are no members, x is returned.
	 */
	public function findMaxX() {
		return length == 0 ? position.x : findMaxXHelper();
	}

	@:noCompletion
	private function findMinXHelper() {
		var value = Math.POSITIVE_INFINITY;
		for (member in members) {
			if (member == null)
				continue;

			var minX:Float = member.position.x;

			if (minX < value)
				value = minX;
		}
		return value;
	}

	@:noCompletion
	private function findMaxXHelper() {
		var value = Math.NEGATIVE_INFINITY;
		for (member in members) {
			if (member == null)
				continue;

			var maxX:Float = member.position.x + (member.size.x * member.scale.x);

			if (maxX > value)
				value = maxX;
		}
		return value;
	}

	/**
	 * Returns the top-most position of the top-most member.
	 * If there are no members, y is returned.
	 */
	public function findMinY() {
		return length == 0 ? position.y : findMinYHelper();
	}

	@:noCompletion
	private function findMinYHelper() {
		var value = Math.POSITIVE_INFINITY;
		for (member in members) {
			if (member == null)
				continue;

			var minY:Float = member.position.y;

			if (minY < value)
				value = minY;
		}
		return value;
	}

	/**
	 * Returns the top-most position of the top-most member.
	 * If there are no members, y is returned.
	 */
	public function findMaxY() {
		return length == 0 ? position.y : findMaxYHelper();
	}

	@:noCompletion
	private function findMaxYHelper() {
		var value = Math.NEGATIVE_INFINITY;
		for (member in members) {
			if (member == null)
				continue;

			var maxY:Float = member.position.y + (member.size.y * member.scale.y);

			if (maxY > value)
				value = maxY;
		}
		return value;
	}

	@:noCompletion
	private function get_size() {
		if(length == 0)
			return Vector2D.ZERO;

		return size.set(findMaxXHelper() - findMinXHelper(), findMaxYHelper() - findMinYHelper());
	}

	@:noCompletion
	private function set_tint(value:BlissColor):BlissColor {
		return tint = value;
	}

	override function render() {
		for(member in members) {
			if(member == null || !member.exists || !member.visible) continue;
			member.position.x += position.x;
			member.position.y += position.y;
		}
		super.render();
        for(member in members) {
			if(member == null || !member.exists || !member.visible) continue;
            for(camera in member.cameras) {
                @:privateAccess
                camera._queuedRenders.push(() -> {
                    member.position.x -= position.x;
			        member.position.y -= position.y;
                });
            }
		}
	}
}
