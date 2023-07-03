package bliss.engine;

class Object {
	/**
	 * Whether or not this object is currently
	 * allowed to update.
	 */
	public var active:Bool = true;

	public function new() {}

	public function update(elapsed:Float) {}
}