package bliss.engine;

class Object {
	/**
	 * Whether or not this object is currently
	 * allowed to update.
	 */
	public var active:Bool = true;

	/**
	 * Whether or not this object can draw onto the window.
	 */
	public var visible:Bool = true;

	/**
	 * Useful state for many game objects - "dead" (`!alive`) vs `alive`. `kill()` and
	 * `revive()` both flip this switch (along with `exists`, but you can override that).
	 */
	public var alive:Bool = true;

	/**
	 * Whether or not `update()` and `render()` are automatically called by scenes or groups.
	 */
	public var exists:Bool = true;

	/**
	 * Creates a new Object instance.
	 */
	public function new() {}

	/**
	 * The function that updates this object.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	public function update(elapsed:Float) {}

	/**
	 * The function that renders this object to the screen.
	 */
	public function render() {}

	/**
	 * Kills this object and makes it unable to update or render
	 * instantly. Call `revive()` to instantly restore those abilities.
	 */
	public function kill() {
		alive = false;
		exists = false;
	}

	/**
	 * Revives this object and makes it able to update or render
	 * again instantly. Call `kill()` to instantly remove those abilities.
	 */
	public function revive() {
		alive = true;
		exists = true;
	}

	/**
	 * Destroys this object.
	 * 
	 * Makes this object potentially unusable afterwards!
	 */
	public function destroy() {}
}