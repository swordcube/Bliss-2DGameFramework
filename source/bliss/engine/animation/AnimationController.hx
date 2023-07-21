package bliss.engine.animation;

import bliss.backend.Debug;
import bliss.backend.interfaces.IObject;
import bliss.engine.utilities.AtlasFrames;

using StringTools;

class AnimationController implements IObject {
    public var finishCallback:String->Void;

    /**
     * The currently loaded animation.
     * 
     * #### ⚠⚠ WARNING!! ⚠⚠ 
     * This can be `null`!
     */
    public var curAnim:Animation;

    /**
     * The name of the currently loaded animation.
     */
    public var name(get, never):String;

    /**
     * Whether or not the current animation should be reversed.
     */
    public var reversed:Bool = false;

    /**
     * Whether or not the current animation is finished.
     */
    public var finished:Bool = false;

    /**
	 * Adds a new animation to the sprite.
	 *
	 * @param   name        What this animation should be called (e.g. `"run"`).
	 * @param   frames      An array of indices indicating what frames to play in what order (e.g. `[0, 1, 2]`).
	 * @param   frameRate   The speed in frames per second that the animation should play at (e.g. `40` fps).
	 * @param   loop        Whether or not the animation is looped or just plays once.
	 */
    public function add(name:String, frames:Array<Int>, ?frameRate:Int = 30, ?loop:Bool = true) {
        var atlas:AtlasFrames = parent.frames;
        if(atlas == null) return;

        // Then filter it to only the frames specified
        var neededFrames:Array<FrameData> = [];
        for(num in frames) 
            neededFrames.push(atlas.frames[num]);

        // Then add the animation
        var animationData = new Animation(name, frameRate, loop);
        @:privateAccess
        animationData._frames = neededFrames;

        animations.set(name, animationData);
    }

    /**
	 * Adds a new animation to the sprite.
	 *
	 * @param   name        What this animation should be called (e.g. `"run"`).
	 * @param   prefix      Common beginning of image names in atlas (e.g. `"tiles-"`).
	 * @param   frameRate   The animation speed in frames per second.
	 * @param   loop        Whether or not the animation is looped or just plays once.
	 */
    public function addByPrefix(name:String, prefix:String, ?frameRate:Int = 30, ?loop:Bool = true) {
        var atlas:AtlasFrames = parent.frames;
        if(atlas == null) return;

        // Get the frames for the animation we want
        // Then make the animation data
        var animationData = new Animation(name, frameRate, loop);
        for(frame in atlas.frames) {
            if(frame.name.startsWith(prefix)) {
                @:privateAccess
                animationData._frames.push(frame);
            }
        }

        // Add the animation
        animations.set(name, animationData);
    }

	/**
	 * Adds a new animation to the sprite.
	 *
	 * @param   mame        What this animation should be called (e.g. `"run"`).
	 * @param   prefix      Common beginning of image names in the atlas (e.g. "tiles-").
	 * @param   indices     An array of numbers indicating what frames to play in what order (e.g. `[0, 1, 2]`).
	 * @param   frameRate   The speed in frames per second that the animation should play at (e.g. `40` fps).
	 * @param   loop        Whether or not the animation is looped or just plays once.
	 */
    public function addByIndices(name:String, prefix:String, indices:Array<Int>, ?frameRate:Int = 30, ?loop:Bool = true) {
        var atlas:AtlasFrames = parent.frames;
        if(atlas == null) return;

        // Get all of the frames of the animation we want
        var allFrames:Array<FrameData> = [];
        for(frame in atlas.frames) {
            if(frame.name.startsWith(prefix))
                allFrames.push(frame);
        }

        // Then filter it to only the frames specified in the indices
        var neededFrames:Array<FrameData> = [];
        for(num in indices) 
            neededFrames.push(allFrames[num]);

        // Then add the animation
        var animationData = new Animation(name, frameRate, loop);
        @:privateAccess
        animationData._frames = neededFrames;

        animations.set(name, animationData);
    }


	/**
	 * Removes an animation.
	 *
	 * @param name  The name of animation to remove.
	 */
	public function remove(name:String):Void {
        var anim:Animation = animations.get(name);
        if(anim != null)
            animations.remove(name);
    }

    public function play(name:String, ?force:Bool = false, ?reversed:Bool = false, ?frame:Int = 0) {
        if(!exists(name) || animations.get(name) == null)
            return Debug.log(WARNING, 'Animation called "$name" doesn\'t exist!');

        if(this.name == name && !finished && !force) return;

        _elapsedTime = 0;
        finished = false;
        curAnim = animations.get(name);
        curAnim.curFrame = frame;

        @:privateAccess {
            if(parent != null && curAnim != null && curAnim._frames[0] != null) {
                parent.size.x = curAnim._frames[0].width;
                parent.size.y = curAnim._frames[0].height;
                parent.centerOrigin();
            }
        }

        this.reversed = reversed;
    }

    /**
     * Returns whether or not a specified animation exists.
     * 
     * @param name  The animation to check.
     */
    public function exists(name:String) {
        return animations.exists(name);
    }

    /**
     * Returns animation data for a specified animation.
     * 
     * @param name  The name of the animation to return. (Returns `null` if non-existent)
     */
    public function getByName(name:String) {
        return animations.get(name);
    }

    /**
     * Removes all animations added.
     */
    public function reset() {
        curAnim = null;
        for(anim in animations)
            anim = null;
        
        animations.clear();
    }

    /**
     * Set an animation specific offset.
     * 
     * @param name The name of the animation.
     * @param x The new x offset,
     * @param y The new y offset.
     */
    public function setAnimOffset(name:String, x:Float, y:Float) {
        var anim = animations.get(name);
        if(anim != null)
            anim.offset.set(x, y);
    }

    //##-- VARIABLES/FUNCTIONS YOU SHOULDN'T TOUCH!! --##//
    public function new(parent:Sprite) {
        this.parent = parent;
    }

    public function update(elapsed:Float) {
        if(finished || curAnim == null) return;
        
        _elapsedTime += elapsed;
        if(_elapsedTime >= (1 / curAnim.frameRate)) {
            if(curAnim.curFrame < curAnim.numFrames - 1)
                curAnim.curFrame++;
            else {
                if(curAnim.loop)
                    curAnim.curFrame = 0;
                else {
                    finished = true;
                    if(finishCallback != null)
                        finishCallback(name);
                }
            }
            _elapsedTime = 0;
        }
    }

    public function destroy() {
        animations = null;
        curAnim = null;
        reversed = false;
        finished = true;
    }

    @:noCompletion
    private var _elapsedTime:Float = 0;

    @:noCompletion
    private var parent:Sprite;

    @:noCompletion
    private var animations:Map<String, Animation> = [];

    @:noCompletion
    private function get_name():String {
		var animName:String = "";
		if (curAnim != null)
			animName = curAnim.name;
		
		return animName;
    }

	/**
	 * Required for `IObject`, does nothing.
	 */
	public function render() {}

    /**
	 * Required for `IObject`, does nothing.
	 */
	public function kill() {}

    /**
	 * Required for `IObject`, does nothing.
	 */
	public function revive() {}
}