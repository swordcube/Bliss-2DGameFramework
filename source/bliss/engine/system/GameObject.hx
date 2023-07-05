package bliss.engine.system;

import bliss.engine.Scene;
import bliss.backend.Application;

@:allow(bliss.engine.system.Game)
class GameObject {
	/**
	 * The currently loaded scene.
	 */
	public var scene:Scene;

	public function update(elapsed:Float) {
		if(scene != _requestedScene)
			switchScene();

		if(scene != null)
			scene.update(elapsed);

		Game.cameras.update(elapsed);
	}

	public function render() {
		if(scene != null)
			scene.render();

		Game.cameras.render();
	}

	public function switchScene() {
		// Destroy old scene if possible
		if(scene != null)
			scene.destroy();

		// Switch the scene to the currently requested one
		scene = _requestedScene;
		scene.create();
		scene.createPost();
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private var _requestedScene:Scene;

	@:noCompletion
	private function new() {}
}