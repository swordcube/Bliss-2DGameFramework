package bliss.testing;

import bliss.engine.Scene;
import bliss.engine.Sprite;
import bliss.engine.Camera;
import bliss.engine.system.Game;
import bliss.backend.graphics.BlissColor;

class TestScene extends Scene {
	var test:Sprite;
	var test2:Sprite;

	override function create() {
		super.create();

		var newCam:Camera = new Camera();
		Game.cameras.add(newCam);

		add(test = new Sprite(50, 50, "assets/haxe.png"));
		test.scale.set(0.3, 0.3);
		test.centerOrigin();
		test.tint = BlissColor.COLOR_LIME;

		add(test2 = new Sprite(150, 150, "assets/haxe.png"));
		test2.scale.set(0.3, 0.3);
		test2.centerOrigin();
		test2.camera = newCam;

		newCam.zoom *= 2;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		test.angle += elapsed * 160;
	}
}