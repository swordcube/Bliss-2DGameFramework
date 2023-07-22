package bliss.engine;

import bliss.backend.Debug;

import bliss.engine.utilities.SortUtil;

using bliss.engine.utilities.ArrayUtil;

class Group<T:Object> extends Object {
	public var members:Array<T> = [];

	/**
	 * The maximum capacity of this group. Default is `0`, meaning no max capacity, and the group can just grow.
	 */
	public var maxSize(default, set):Int;

	/**
	 * The length of this group.
	 * 
	 * Use this variable instead of `members.length`
	 * for better safety and performance!
	 */
	public var length:Int = 0;

	/**
	 * Creates a new Group instance.
	 * @param maxSize The maximum amount of members allowed in this group
	 */
	public function new(maxSize:Int = 0) {
		super();
		maxSize = Std.int(Math.abs(maxSize));
	}

	/**
	 * Adds an object to this group.
	 * 
	 * @param object The object to add to this group.
	 */
	public function add(object:T) {
		if(members.contains(object)) {
			Debug.log(WARNING, "Cannot add an object that was already added to this Group!");
			return object;
		}

		var index:Int = getFirstNull();
		if(index != -1) {
			members[index] = object;

			if (index >= length)
				length = index + 1;

			return object;
		}

		if(maxSize > 0 && length >= maxSize)
			return object;

		members.push(object);
		length++;

		return object;
	}

	/**
	 * Inserts an object to this group at a specified position.
	 * 
	 * @param object The object to insert into this group.
	 */
	public function insert(position:Int, object:T) {
		if(members.contains(object)) {
			Debug.log(WARNING, "Cannot add an object that was already added to this Group!");
			return object;
		}

		if(position < length && members[position] == null) {
			members[position] = object;
			return object;
		}

		if(maxSize > 0 && length >= maxSize)
			return object;

		members.insert(position, object);
		length++;

		return object;
	}

	/**
	 * Removes an object from this group.
	 * 
	 * @param object The object to remove from this group.
	 * @param splice Whether or not to completely remove the object from the members list.
	 */
	public function remove(object:T, splice:Bool = true) {
		if(!members.contains(object)) {
			Debug.log(WARNING, "Cannot remove an object that wasn't added to this Group!");
			return object;
		}
		
		if(splice) {
			members.remove(object);
			length--;
		} else
			members[members.indexOf(object)] = null;

		return object;
	}

	/**
	 * Remove all objects from this group.
	 * 
	 * ⚠️ **WARNING**: Does not `destroy()` or `kill()` any of these objects!
	 */
	public function clear() {
		length = 0;
		members.clearArray();
	}

	/**
	 * Call this function to retrieve the first index set to `null`.
	 * Returns `-1` if no index stores a `null` object.
	 *
	 * @return  An `Int` indicating the first `null` slot in the group.
	 */
	public function getFirstNull():Int {
		for(i => object in members) {
			if(object != null) continue;
			return i;
		}
		return -1;
	}

	/**
	 * Call this function to retrieve the first object with `exists == false` in the group.
	 * This is handy for recycling in general, e.g. respawning enemies.
	 *
	 * @param   objectClass   An optional parameter that lets you narrow the
	 *                        results to instances of this particular class.
	 * @param   force         Force the object to be an `ObjectClass` and not a super class of `ObjectClass`.
	 */
	public function getFirstAvailable(?objectClass:Class<T>, force:Bool = false):T {
		var i:Int = 0;
		var object:Object = null;

		while(i < length) {
			object = members[i++];

			if(object != null && !object.exists && (objectClass == null || Std.isOfType(object, objectClass))) {
				if(force && Type.getClassName(Type.getClass(object)) != Type.getClassName(objectClass))
					continue;
				
				return members[i - 1];
			}
		}

		return null;
	}

	/**
	 * Call this function to sort the group according to a particular value and order.
	 * For example, to sort game objects for Zelda-style overlaps you might call
	 * `group.sort(SortUtil.byY, SortUtil.ASCENDING)` at the bottom of your `FlxState#update()` override.
	 *
	 * @param   func       The sorting function to use - you can use one of the premade ones in
	 *                     `SortUtil` or write your own using `SortUtil.byValues()` as a "backend".
	 * @param   order      A constant that defines the sort order.
	 *                     Possible values are `SortUtil.ASCENDING` (default) and `SortUtil.DESCENDING`.
	 */
	public inline function sort(func:Int->T->T->Int, order:Int = SortUtil.ASCENDING):Void {
		members.sort(func.bind(order));
	}

	/**
	 * Recycling is designed to help you reuse game objects without always re-allocating or "newing" them.
	 * It behaves differently depending on whether `maxSize` equals `0` or is bigger than `0`.
	 *
	 * `maxSize > 0` / "rotating-recycling"
	 *   - at capacity:  returns the next object in line.
	 *   - otherwise:    returns a new object.
	 *
	 * `maxSize == 0` / "grow-style-recycling"
	 *   - tries to find the first object that isn't null
	 *   - otherwise: adds a new object to the `members` array
	 *
	 * WARNING: If this function needs to create a new object, and no object class was provided,
	 * it will return `null` instead of a valid object!
	 *
	 * @param   objectClass     The class type you want to recycle (e.g. `Sprite`, `EvilRobot`, etc).
	 * @param   objectFactory   Optional factory function to create a new object
	 *                          if there aren't any dead members to recycle.
	 *                          If `null`, `Type.createInstance()` is used,
	 *                          which requires the class to have no constructor parameters.
	 * @param   force           Force the object to be an `ObjectClass` and not a super class of `ObjectClass`.
	 * @param   revive          Whether recycled members should automatically be revived
	 *                          (by calling `revive()` on them).
	 */
	public function recycle(?objectClass:Class<T>, ?objectFactory:Void->T, force:Bool = false, revive:Bool = true) {
		var object:Object = null;

		// Rotated recycling
		if(maxSize > 0) {
			// Create new instance
			if(length < maxSize)
				return recycleCreateObject(objectClass, objectFactory);
			
			// Get the next member if at capacity
			else {
				object = members[_marker++];

				if(_marker >= maxSize)
					_marker = 0;

				if(revive)
					object.revive();

				return cast object;
			}
		}
		// Grow-style recycling - Grab the first non-null object or create a new one
		else {
			object = getFirstAvailable(objectClass, force);

			if(object != null) {
				if(revive)
					object.revive();
				return cast object;
			}

			return recycleCreateObject(objectClass, objectFactory);
		}
	}

	/**
	 * The function that updates this group.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	override function update(elapsed:Float) {
		if(!active) return;
		for(object in members) {
			if(object == null || !object.exists || !object.active) continue;
			object.update(elapsed);
		}
	}

	/**
	 * The function that renders this group to the screen.
	 */
	override function render() {
		if(!visible) return;

		var _realDefaultCameras:Array<Camera> = Camera.defaultCameras;
		if(cameras != null)
			Camera.defaultCameras = cameras;

		for(object in members) {
			if(object == null || !object.exists || !object.visible) continue;
			object.render();
		}

		Camera.defaultCameras = _realDefaultCameras;
	}

	/**
	 * Calls `kill()` on the group's `members` and then on the group itself.
	 * You can revive this group later via `revive()` after this.
	 */
	override function kill() {
		for(object in members) {
			if(object == null || !object.exists) continue;
			object.kill();
		}
		super.kill();
	}

	/**
	 * Calls `revive()` on the group's members and then on the group itself.
	 */
	override function revive() {
		for(object in members) {
			if(object == null || object.exists) continue;
			object.revive();
		}
		super.revive();
	}

	/**
	 * Destroys this group.
	 * 
	 * Makes this group and every object in it
	 * potentially unusable afterwards!
	 */
	override function destroy() {
		for(object in members) {
			if(object == null) continue;
			object.destroy();
		}
		members = null;
		length = 0;
		super.destroy();
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	/**
	 * Internal helper variable for recycling objects.
	 */
	@:noCompletion
	private var _marker:Int = 0;

	@:noCompletion
	private inline function recycleCreateObject(?objectClass:Class<T>, ?objectFactory:Void->T):T {
		var object:T = null;

		if (objectFactory != null)
			add(object = objectFactory());
		else if (objectClass != null)
			add(object = Type.createInstance(objectClass, []));

		return object;
	}

	@:noCompletion
	private function set_maxSize(size:Int):Int {
		maxSize = Std.int(Math.abs(size));

		if(_marker >= maxSize)
			_marker = 0;

		if(maxSize == 0 || members == null || maxSize >= length)
			return maxSize;

		// If the max size has shrunk, we need to get rid of some objects
		var i:Int = maxSize;
		var l:Int = length;
		var object:Object = null;

		while(i < l) {
			object = members[i++];

			if(object != null)
				object.destroy();
		}

		ArrayUtil.setLength(members, maxSize);
		length = members.length;

		return maxSize;
	}
}