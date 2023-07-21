package bliss.engine.utilities;

import bliss.engine.Object2D;

/**
 * Helper class for sort() in FlxTypedGroup, but could theoretically be used on regular arrays as well.
 */
class SortUtil {
	public static inline var ASCENDING:Int = -1;
	public static inline var DESCENDING:Int = 1;

	/**
	 * You can use this function in TypedGroup.sort() to sort Object2Ds by their y values.
	 */
	public static inline function byY(order:Int, obj1:Object2D, obj2:Object2D):Int {
		return byValues(order, obj1.position.y, obj2.position.y);
	}

	/**
	 * You can use this function as a backend to write a custom sorting function (see byY() for an example).
	 */
	public static inline function byValues(order:Int, value1:Float, value2:Float):Int {
		var result:Int = 0;

		if (value1 < value2)
			result = order;
		else if (value1 > value2)
			result = -order;

		return result;
	}
}
