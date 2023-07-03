package bliss.engine;

import bliss.backend.Debug;

class Group<T:Object> extends Object {
	public var members:Array<T> = [];

	/**
	 * The length of this group.
	 * 
	 * Use this variable instead of `members.length`
	 * for better safety and performance!
	 */
	public var length:Int = 0;

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
	 * The function that updates this group.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	override function update(elapsed:Float) {
		if(!active) return;
		for(object in members) {
			if(object == null || !object.active) continue;
			object.update(elapsed);
		}
	}

	/**
	 * The function that renders this group to the screen.
	 */
	override function render() {
		if(!visible) return;
		for(object in members) {
			if(object == null || !object.visible) continue;
			object.render();
		}
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
	}
}