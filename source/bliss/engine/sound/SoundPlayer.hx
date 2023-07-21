package bliss.engine.sound;

import bliss.backend.Application;
import bliss.backend.interfaces.ISound;
import bliss.backend.sound.BlissSound;

/**
 * A class for playing short sound effects such as scrolling/player sfx.
 * 
 * You unfortunately cannot get the time of these sounds,
 * `MusicPlayer` is best suited for longer sounds and you can get the time of them.
 */
class SoundPlayer extends Object implements ISound {
	/**
	 * Whether or not this sound is playing.
	 */
	public var playing:Bool = false;

	/**
	 * Whether or not this sound is paused.
	 */
	public var paused:Bool = false;

	/**
	 * The volume multiplier of this sound.
	 */
	public var volume(default, set):Float;

	/**
	 * The pitch multiplier of this sound.
	 */
	public var pitch(default, set):Float = 1;

	/**
	 * The length of this sound in milliseconds.
	 */
	public var length(get, never):Float;

	/**
	 * Whether or not this sound is looping.
	 */
	public var loop:Bool;

	/**
	 * A callback that gets ran when
	 * this sound has just finished.
	 */
	public var onComplete:Void->Void;

	public function new(sound:BlissSoundAsset, ?volume:Float = 1, ?loop:Bool = true) {
		super();
		if (sound is BlissSound)
			this.sound = sound;
		else if (sound is String)
			this.sound = BlissSound.fromFile(cast(sound, String));

		this.sound.useCount++;
		this.volume = volume;
		this.loop = loop;

		final window = Application.self.window;
		window.onFocusIn.connect(onFocusIn);
		window.onFocusOut.connect(onFocusOut);
	}

	override function update(elapsed:Float) {
		if(sound == null)
			return;

		if(!Rl.isSoundPlaying(sound.sound) && !loop && playing)
            stop();

        if(!Rl.isSoundPlaying(sound.sound) && loop && playing)
            Rl.playSound(sound.sound);
	}

	public function onFocusIn() {
		if(paused) return;
		Rl.resumeSound(sound.sound);
	}

	public function onFocusOut() {
		if(paused) return;
		Rl.pauseSound(sound.sound);
	}

	/**
	 * Plays this sound.
	 */
	public function play(?forceRestart:Bool = false, ?startTime:Float = 0) {
		if (sound == null || (playing && !forceRestart && !paused))
			return this;

        if(paused)
            resume();
        else
		    Rl.playSound(sound.sound);

		return this;
	}

	/**
	 * Stops this sound.
	 */
	public function stop() {
        if(sound == null)
            return this;

		playing = false;
        Rl.stopSound(sound.sound);
		onComplete();
		return this;
	}

	/**
	 * Pauses this sound.
	 */
	public function pause() {
        if(sound == null)
            return this;

		paused = true;
		Rl.pauseSound(sound.sound);
		return this;
	}

	/**
	 * Resumes this sound.
	 */
	public function resume() {
        if(sound == null)
            return this;

		paused = false;
		Rl.resumeSound(sound.sound);
		return this;
	}

	@:noCompletion
	private var sound:BlissSound;

	@:noCompletion
	private function set_volume(v:Float):Float {
		if (sound != null)
			Rl.setSoundVolume(sound.sound, v);

		return volume = v;
	}

	@:noCompletion
	private function set_pitch(v:Float):Float {
		if (sound != null)
			Rl.setSoundPitch(sound.sound, v);

		return pitch = v;
	}

	@:noCompletion
	private function get_length():Float {
		var ret:Float = (sound != null) ? (sound.sound.frameCount / sound.sound.stream.sampleRate) * 1000 : 0;
		if(ret < 0) ret = 0;
		return ret;
	}

	override function destroy() {
		final window = Application.self.window;
		window.onFocusIn.disconnect(onFocusIn);
		window.onFocusOut.disconnect(onFocusOut);
		sound.useCount--;
		super.destroy();
	}
}
