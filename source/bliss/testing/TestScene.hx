package bliss.testing;

import bliss.engine.Scene;
import bliss.engine.Sprite;
import bliss.engine.system.Game;
import bliss.backend.graphics.BlissColor;

class TestScene extends Scene {
	var test:Sprite;

	override function create() {
		super.create();

		add(test = new Sprite(-50, -50, "assets/haxe.png"));
		test.scale.set(0.3, 0.3);
		test.centerOrigin();
		test.tint = BlissColor.COLOR_LIME;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(Game.keys.pressed(UP)) test.position.y -= elapsed * 600;
		if(Game.keys.pressed(DOWN)) test.position.y += elapsed * 600;
		if(Game.keys.pressed(LEFT)) test.position.x -= elapsed * 600;
		if(Game.keys.pressed(RIGHT)) test.position.x += elapsed * 600;
	}
}