package;

import bliss.Project;
import bliss.engine.system.Game;
import bliss.backend.graphics.BlissColor;

class Main {
	static function main() {
		// Set project settings
		Project.windowTitle = "Bliss Testing Project";
		Project.windowBGColor = 0xFF1b1b1c; // Color has to be transparent otherwise raylib goes insane
		Project.windowWidth = 1280;
		Project.windowHeight = 720;

		// Start the game
		Game.create(60, new bliss.testing.TestScene());
	}
}
