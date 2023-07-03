package bliss.testing;

import bliss.engine.Scene;
import bliss.engine.Sprite;

class TestScene extends Scene {
	override function create() {
		var testSprite = new Sprite(30, 30);
		add(testSprite);
	}
}