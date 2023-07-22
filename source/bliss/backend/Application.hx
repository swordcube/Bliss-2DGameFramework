package bliss.backend;

import bliss.Project;

@:access(bliss.backend.Window)
class Application {
	public static var self:Application = null;

	/**
	 * The framerate of every window that gets
	 * attached to this application.
	 * 
	 * Each window can have their own unique framerates
	 * after the window is first attached.
	 */
	public static var framerate:Int = 60;

	/**
	 * The time in seconds between the last and current frame.
	 */
	public var deltaTime:Float = 0;

	/**
	 * The main window that was automatically created
	 * when this application opened.
	 */
	public var window:Window;

	/**
	 * Whether or not this application is running.
	 */
	public var running:Bool = false;

	/**
	 * Makes a new application instance.
	 * Allows windows to properly update and draw.
	 */
	public static inline function create() {
		if(self != null) {
			Debug.log(WARNING, "An Application instance was already made!");
			return;
		}
		haxe.Log.trace = (v, ?pos) -> {
            Debug.log(GENERAL, v, pos);
        };
		self = new Application();

		// Creates a window at the center of the screen.
		// The application will update this window.
		self.window = Window.create(Project.windowTitle, null, null, Project.windowWidth, Project.windowHeight, framerate);
	}

	/**
	 * Starts continously updating every window.
	 */
	public static inline function start() {
		var app:Application = Application.self;
		app.running = true;

		while(app.running)
			app.update();
	}

	/**
	 * Stops continously updating every window
	 * and closes them all.
	 */
	public static inline function stop() {
		var app:Application = Application.self;
		app.running = false;

		// Application stopped, so windows attached to it
		// must stop aswell.
		for(window in Window._windows)
			window.close();
	}

	public inline function update() {
		var oldTime:Float = Sys.time();

		for(window in Window._windows) {
			if(!running) break;

			window.update(deltaTime);

			if(!window.closed)
				window.render();
		}
		if(Window._windows.length < 1)
			Application.stop();

		deltaTime = Math.max(Sys.time() - oldTime, 0);
	}

	//##-- Used internally, please use Application.create --##//
	@:noCompletion
	@:noPrivateAccess
	private function new() {}
}