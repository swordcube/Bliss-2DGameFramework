package bliss.engine;

import bliss.backend.graphics.BlissColor;
import bliss.engine.animation.Animation;
import bliss.engine.animation.AnimationController;
import bliss.backend.graphics.BlissGraphic;

import bliss.engine.Camera;
import bliss.engine.system.Game;
import bliss.engine.system.Vector2D;

import bliss.engine.utilities.Axes;
import bliss.engine.utilities.MathUtil;
import bliss.engine.utilities.AtlasFrames;

class Sprite extends Object2D {
	/**
	 * The default antialiasing of every new sprite.
	 * 
	 * Set this to `false` to make all sprites aliased!
	 */
	public static var defaultAntialiasing:Bool = true;

	/**
	 * The graphic that this sprite renders.
	 */
	 @:isVar public var graphic(get, set):BlissGraphic;

	/**
	 * The collection of frames that this sprite
	 * can animate with.
	 */
	public var frames(default, set):AtlasFrames;

	/**
	 * A helper for easily adding, removing, and playing animations.
	 */
	public var animation:AnimationController;

	/**
	 * An X & Y multiplier to the sprite's size.
	 */
	public var scale(default, set):Vector2D;

	/**
	 * The X size of this sprite multiplied by this sprite's scale.
	 * 
	 * Basically just a shortcut to `size.x * Math.abs(scale.x)`.
	 */
	public var width(get, never):Float;

	/**
	 * The X size of this sprite multiplied by this sprite's scale.
	 * 
	 * Basically just a shortcut to `size.y * Math.abs(scale.y)`.
	 */
	public var height(get, never):Float;

	/**
	 * The origin at which the sprite should rotate at.
	 * 
	 * Ranges from 0 to the sprite's width/height.
	 */
	public var origin(default, set):Vector2D;

	/**
	 * The position of the sprite's graphic relative to its hitbox. For example, `offset.x = 10;` will
	 * show the graphic 10 pixels right of the hitbox.
	 * 
	 * Likely needs to be adjusted after changing a sprite's `size` or `scale`.
	 */
	public var offset(default, set):Vector2D;

	/**
	 * How much the sprite moves with the camera.
	 * Can be used for parallax.
	 */
	public var scrollFactor(default, set):Vector2D;

	/**
	 * Controls whether the object is smoothed when rotated, affects performance.
	 */
	public var antialiasing:Bool = defaultAntialiasing;

	/**
	 * Creates a new Sprite instance.
	 * 
	 * @param x The X position of this new object in world space, Starts from the top left.
	 * @param y The Y position of this new object in world space, Starts from the top left.
	 * @param presetGraphic The graphic to display on the sprite.
	 */
	public function new(x:Float = 0, y:Float = 0, ?presetGraphic:BlissGraphicAsset) {
		super(x, y, 0, 0);

		if(presetGraphic != null)
			loadGraphic(presetGraphic);
	}
	
	override function initVars() {
		scale = new Vector2D(1, 1);
		origin = new Vector2D(0, 0);
		offset = new Vector2D(0, 0);
		scrollFactor = new Vector2D(1, 1);
		animation = new AnimationController(this);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		animation.update(elapsed);
	}

	/**
	 * Makes the sprite start rendering any specified graphic.
	 * 
	 * @param graphic The graphic to load.
	 */
	public function loadGraphic(graphic:BlissGraphicAsset) {
		if(graphic is BlissGraphic)
			this.graphic = graphic;
		else if(graphic is String)
			this.graphic = BlissGraphic.fromFile(cast(graphic, String));
		
		return this;
	}

	public function makeGraphic(width:Int, height:Int, color:BlissColor = BlissColor.COLOR_WHITE, ?key:String) {
		if(key == null) key = '${width}x${height}:${Std.string(color)}';

		if(Game.graphic.isCached(key))
			graphic = Game.graphic.get(key);
		else {
			final generated:Rl.Texture2D = Rl.loadTextureFromImage(Rl.genImageColor(width, height, color.toRaylib()));
			graphic = Game.graphic.cacheGraphic(BlissGraphic.fromRaylib(generated));
		}
		return this;
	}

	/**
	 * Helper function that adjusts the offset automatically to center the bounding box within the graphic.
	 *
	 * @param adjustPosition Adjusts the actual X and Y position just once to match the offset change.
	 */
	public function centerOffsets(adjustPosition:Bool = false):Void {
		offset.x = (size.x - (size.x * scale.x)) * -0.5;
		offset.y = (size.x - (size.y * scale.y)) * -0.5;

		if(adjustPosition) {
			position.x -= offset.x;
			position.y -= offset.y;
		}
	}

	/**
	 * Sets the sprite's origin to its center - useful after adjusting
	 * `scale` to make sure rotations work as expected.
	 */
	public inline function centerOrigin() {
		origin.set(size.x * 0.5, size.y * 0.5);
	}

	/**
	 * Gets the midpoint of this sprite.
	 */
	public inline function getMidpoint() {
		return new Vector2D(width * 0.5, height * 0.5);
	}

	/**
	 * Sets the position of the sprite to the center of the screen.
	 */
	public inline function screenCenter(axes:Axes = XY) {
		if(axes.x)
			position.x = (Game.width - size.x) * 0.5;

		if(axes.y)
			position.y = (Game.height - size.y) * 0.5;
	}

	/**
	 * The function that renders this sprite to the screen.
	 */
	override function render() {
		if(alpha == 0) return;

		for(camera in cameras) {
			@:privateAccess
			camera._queuedRenders.push(() -> renderComplex(camera));
		}
	}

	/**
	 * Destroys this sprite.
	 * 
	 * Makes this sprite potentially unusable afterwards!
	 */
	override function destroy() {
		@:privateAccess
		var _assets:Array<BlissGraphic> = [for(asset in Game.graphic._cache) asset];
		
		if(frames != null && frames.graphic != null && !_assets.contains(frames.graphic))
			frames.graphic.useCount--;
		scale = null;
		origin = null;
		offset = null;
		_renderSpritePos = null;
		super.destroy();
	}

	//##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
	@:noCompletion
	private function set_frames(v:AtlasFrames) {
		if(frames != null && frames.graphic != null)
			frames.graphic.useCount--;

		animation.reset();
		size.set(v.frames[0]?.width ?? 0, v.frames[0]?.height ?? 0);
		
		v.graphic.useCount++;
		return frames = v;
	}

	@:noCompletion
	private function get_graphic() {
		return frames?.graphic;
	}

	@:noCompletion
	private function set_graphic(v:BlissGraphic) {
		frames = AtlasFrames.fromGraphic(v);
		return v;
	}

	@:noCompletion
	private function get_width() {
		return size.x * Math.abs(scale.x);
	}

	@:noCompletion
	private function get_height() {
		return size.y * Math.abs(scale.y);
	}

	@:noCompletion
	private var _renderSpritePos:Vector2D = new Vector2D(0, 0);

	// i'ma be honest this function is kinda messy
	// but i do not wanna rework it because i do not feel like
	// most likely breaking the entire function
	@:noCompletion
	private function renderComplex(camera:Camera) {
		// If the graphic or it's internal texture are somehow null
		// or the sprite is off screen or the attached camera's
		// zoom is 0, Don't try to render.
		@:privateAccess
		if(graphic?.texture == null || !camera.isOnScreen(this) || camera.zoom.x == 0 || camera.zoom.y == 0)
			return;

		final radians = (angle % 360) * MathUtil.FULL_PI / 180;
		final cosMult = Math.cos(radians);
		final sinMult = Math.sin(radians);

		final ogAngle:Float = angle;
		angle += camera.angle;
		angle %= 360;

		final absScale:Vector2D = scale.abs();
		final absZoom:Vector2D = camera.zoom.abs();

		@:privateAccess
		final _rawTexture:Rl.Texture2D = cast(graphic.texture, Rl.Texture2D);

		if(_rawTexture != null)
			Rl.setTextureFilter(_rawTexture, antialiasing ? Rl.TextureFilter.BILINEAR : Rl.TextureFilter.POINT);

		final _animation:Animation = animation.curAnim;

		@:privateAccess
		final _curFrameData:FrameData = _animation?._frames[_animation.curFrame] ?? frames.frames[0];

		final _ot:Float = tint.alphaFloat;
		tint.alphaFloat = alpha;

		_renderSpritePos.set(
			position.x + ((origin.x * scale.x) + (-0.5 * ((size.x * absScale.x) - size.x))),
			position.y + ((origin.y * scale.y) + (-0.5 * ((size.y * absScale.y) - size.y)))
		);

		var _renderOffset = offset + (_animation?.offset ?? Vector2D.ZERO);
		_renderOffset += new Vector2D(-_curFrameData.frameX, -_curFrameData.frameY);
		_renderOffset -= new Vector2D(camera.scroll.x * scrollFactor.x, camera.scroll.y * scrollFactor.y);

		_renderSpritePos.x += (_renderOffset.x * absScale.x) * cosMult + (_renderOffset.y * absScale.y) * -sinMult;
		_renderSpritePos.y += (_renderOffset.x * absScale.x) * sinMult + (_renderOffset.y * absScale.y) * cosMult;

		@:privateAccess
		var _finalRenderPos:Vector2D = camera.adjustToCamera(_renderSpritePos);

		Rl.drawTexturePro(
			_rawTexture,
			Rl.Rectangle.create(
				_curFrameData.x, _curFrameData.y,
				_curFrameData.width * (scale.x < 0 ? -1 : 1) * (camera.zoom.x < 0 ? -1 : 1),
				_curFrameData.height * (scale.y < 0 ? -1 : 1) * (camera.zoom.x < 0 ? -1 : 1)
			),
			Rl.Rectangle.create(
				_finalRenderPos.x, 
				_finalRenderPos.y, 
				_curFrameData.width * absScale.x * absZoom.x, 
				_curFrameData.height * absScale.y * absZoom.y
			),
			(origin * absScale * absZoom).toRaylib(),
			angle,
			tint.toRaylib()
		);

		tint.alphaFloat = _ot;

		angle = ogAngle;
	}

	// you might think, why have these getters and setters?
	// it's so you can do something when alpha or position is set or whatever.
	@:noCompletion
	private function set_scale(value:Vector2D):Vector2D {
		return scale = value;
	}

	@:noCompletion
	private function set_origin(value:Vector2D):Vector2D {
		return origin = value;
	}

	@:noCompletion
	private function set_offset(value:Vector2D):Vector2D {
		return offset = value;
	}

	@:noCompletion
	private function set_scrollFactor(value:Vector2D):Vector2D {
		return scrollFactor = value;
	}
}