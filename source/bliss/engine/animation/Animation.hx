package bliss.engine.animation;

import bliss.engine.system.Vector2D;
import bliss.engine.utilities.AtlasFrames.FrameData;

class Animation {
    /**
     * The name of the animation.
     */
    public var name:String;

    /**
     * The framerate the animation plays at.
     */
    public var frameRate:Int = 30;

    /**
     * The current frame of the animation.
     */
    public var curFrame:Int = 0;

    /**
     * The amount of frames the animation has.
     */
    public var numFrames(get, never):Int;

    /**
     * The amount of frames the animation has.
     */
    public var frameCount(get, never):Int;

    /**
     * An animation specific offset.
     * Adapts to scale and angle.
     */
    public var offset:Vector2D;

    /**
     * Whether or not this animation loops when finished.
     */
    public var loop:Bool = true;

    public function new(name:String, ?frameRate:Int = 30, ?loop:Bool = true) {
        this.name = name;
        this.frameRate = frameRate;
        this.loop = loop;
        offset = new Vector2D();
    }

    @:noCompletion
    private var _frames:Array<FrameData> = [];

    @:noCompletion
    private function get_numFrames():Int {
        return _frames.length;
    }

    @:noCompletion
    private function get_frameCount():Int {
        return _frames.length;
    }
}