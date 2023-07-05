package bliss.frontend;

import bliss.backend.Debug;
import bliss.engine.Camera;

using bliss.engine.utilities.ArrayUtil;

class CameraFrontEnd {
	/**
	 * Removes all added cameras and makes a new single world camera.
	 */
	public function reset() {
		// Remove all previous cameras
		for(camera in _cameras) {
			if(camera == null) continue;
			camera.destroy();
		}
		_cameras.clearArray();

		// Add a new default camera
		var _defaultCamera:Camera = new Camera();
		Camera.defaultCameras = [_defaultCamera];
		_cameras.push(_defaultCamera);
	}

	/**
	 * Adds a camera to the list of cameras that can update and render.
	 * 
	 * @param camera The camera to add.
	 */
	public function add(camera:Camera) {
		if(_cameras.contains(camera)) {
			Debug.log(WARNING, "This camera has already been added!");
			return camera;
		}
		_cameras.push(camera);
		return camera;
	}

	/**
	 * Removes a camera from the list of cameras that can update and render.
	 * 
	 * @param camera The camera to remove.
	 */
	public function remove(camera:Camera) {
		if(!_cameras.contains(camera)) {
			Debug.log(WARNING, "This camera doesn't exist in the camera list!");
			return camera;
		}
		_cameras.remove(camera);
		return camera;
	}

	/**
	 * Renders every camera to the game window.
	 */
	public function render() {
		for(camera in _cameras) {
			if(camera == null) continue;
			camera.render();
		}
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	public function new() {
		reset();
	}

	@:noCompletion
	private var _cameras:Array<Camera> = [];
}