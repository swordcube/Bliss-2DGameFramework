package bliss.testing;

import bliss.engine.Scene;
import bliss.engine.Sprite;
import bliss.engine.Camera;
import bliss.engine.system.Game;
import bliss.engine.system.Vector2D;
import bliss.backend.graphics.BlissColor;

class TestScene extends Scene {
	var test:Sprite;
	var test2:Sprite;

	var death:Float = 0;
	var newCam:Camera;

	override function create() {
		super.create();

		Game.cameras.add(newCam = new Camera());

		add(test = new Sprite(50, 50, "assets/haxe.png"));
		test.scale.set(0.3, 0.3);
		test.centerOrigin();
		test.tint = BlissColor.COLOR_LIME;

		add(test2 = new Sprite(0, 0, "assets/haxe.png"));
		test2.scale.set(0.3, 0.3);
		test2.centerOrigin();
		test2.screenCenter();
		test2.position -= new Vector2D(60, 60);
		test2.camera = newCam;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		death += elapsed;
		newCam.angle += elapsed * 25;
		test.angle += elapsed * 160;

		var zoom:Float = 1.25 + (Math.sin(death) * 0.5);
		newCam.zoom.set(zoom, zoom);
	}
}