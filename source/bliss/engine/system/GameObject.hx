package bliss.engine.system;

import bliss.backend.Application;

import bliss.managers.MusicManager;
import bliss.managers.CacheManager;

import bliss.engine.Scene;
import bliss.engine.utilities.MathUtil;

@:allow(bliss.engine.system.Game)
class GameObject {
	/**
	 * The currently loaded scene.
	 */
	public var scene:Scene;

	public function update(elapsed:Float) {
		if(_switchingScene) return;
		elapsed = MathUtil.bound(elapsed, 0, Game.maxElapsed);

		if(scene != null) {
			Game.signals.preSceneUpdate.emit(scene);
			scene.update(elapsed);
			Game.signals.postSceneUpdate.emit(scene);
		}
		Game.cameras.update(elapsed);

		if(scene != _requestedScene)
			switchScene();
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
		_switchingScene = true;

		// Destroy old scene if possible
		if(scene != null) {
			Game.signals.preSceneDestroy.emit(scene);
			scene.destroy();
			Game.signals.postSceneDestroy.emit(scene);
		}

		// Reset cameras list
		Game.cameras.reset();

		// Switch the scene to the currently requested one
		scene = _requestedScene;

		Game.signals.preSceneCreate.emit(scene);
		scene.create();
		scene.createPost();
		Game.signals.postSceneCreate.emit(scene);

		_switchingScene = false;
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private var _requestedScene:Scene;

	@:noCompletion
	private var _switchingScene:Bool = false;

	@:noCompletion
	private function new() {}
}