package;

import bliss.Project;
import bliss.engine.system.Game;

class Main {
	static function main() {
		// Set project settings
		Project.windowTitle = "Bliss Testing Project";
		Project.windowBGColor = bliss.backend.graphics.BlissColor.COLOR_CYAN;
		Project.windowWidth = 1280;
		Project.windowHeight = 720;

		// Start the game
		Game.create(120, new bliss.testing.TestScene());
	}
}
