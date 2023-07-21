package bliss.backend.interfaces;

interface IObject extends IDestroyable {
    /**
	 * The function that updates this object.
	 * 
	 * @param elapsed The time in seconds between the last and current frame.
	 */
	public function update(elapsed:Float):Void;

	/**
	 * The function that renders this object to the screen.
	 */
	public function render():Void;

	/**
	 * Kills this object and makes it unable to update or render
	 * instantly. Call `revive()` to instantly restore those abilities.
	 */
	public function kill():Void;

	/**
	 * Revives this object and makes it able to update or render
	 * again instantly. Call `kill()` to instantly remove those abilities.
	 */
	public function revive():Void;
}
