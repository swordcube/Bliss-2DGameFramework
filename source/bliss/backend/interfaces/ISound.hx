package bliss.backend.interfaces;

interface ISound extends IObject {
    /**
     * Whether or not this sound is playing.
     */
    public var playing:Bool;

    /**
     * Plays this sound.
     */
    public function play(?forceRestart:Bool = false, ?startTime:Float = 0):ISound;

    /**
     * Stops this sound.
     */
    public function stop():ISound;

    /**
     * Pauses this sound.
     */
    public function pause():ISound;

    /**
     * Resumes this sound.
     */
    public function resume():ISound;
}