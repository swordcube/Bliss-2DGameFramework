package bliss.engine.system;

import bliss.backend.Application;
import bliss.managers.CacheManager;
import bliss.engine.Scene;

@:allow(bliss.engine.system.Game)
class GameObject {
	/**
	 * The currently loaded scene.
	 */
	public var scene:Scene;

	public function update(elapsed:Float) {
		if(scene != _requestedScene)
			switchScene();

		if(scene != null) {
			Game.signals.preSceneUpdate.emit(scene);
			scene.update(elapsed);
			Game.signals.postSceneUpdate.emit(scene);
		}
		Game.cameras.update(elapsed);
	}

	public function render() {
		if(scene != null) {
			Game.signals.preSceneRender.emit(scene);
			scene.render();
			Game.signals.postSceneRender.emit(scene);
		}
		Game.cameras.render();
	}

	public function switchScene() {
		// Reset cameras list
		Game.cameras.reset();
		
		// Destroy old scene if possible
		if(scene != null) {
			Game.signals.preSceneDestroy.emit(scene);
			scene.destroy();
			Game.signals.postSceneDestroy.emit(scene);
		}

		// Switch the scene to the currently requested one
		scene = _requestedScene;

		Game.signals.preSceneCreate.emit(scene);
		Game.cache.clear();
		scene.create();
		scene.createPost();
		Game.signals.postSceneCreate.emit(scene);
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private var _requestedScene:Scene;

	@:noCompletion
	private function new() {}
}