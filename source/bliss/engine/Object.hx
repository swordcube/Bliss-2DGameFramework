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
	 * Destroys this object.
	 * 
	 * Makes this object potentially unusable afterwards!
	 */
	public function destroy() {}
}