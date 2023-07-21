package bliss.engine.sound;

import bliss.backend.interfaces.ISound;
import bliss.backend.sound.BlissMusic;

/**
 * A class for playing long sounds such as music.
 * Has the ability to get the time of the sound unlike `SoundPlayer`.
 * 
 * This class unfortunately cannot be used very well for short sounds,
 * `SoundPlayer` must be used for those to work as intended.
 */
@:access(bliss.backend.sound.BlissMusic)
class MusicPlayer extends Object implements ISound {
	/**
	 * Whether or not this music is playing.
	 */
	public var playing:Bool = false;

	/**
	 * Whether or not this music is paused.
	 */
	public var paused:Bool = false;

	/**
	 * The volume multiplier of this music.
	 */
	public var volume(default, set):Float;

	/**
	 * The pitch multiplier of this music.
	 */
	public var pitch(default, set):Float = 1;

	/**
	 * The time of this music in milliseconds.
	 */
	public var time(get, set):Float;

	/**
	 * The length of this music in milliseconds.
	 */
	public var length(get, never):Float;

	/**
	 * Whether or not this music is looping.
	 */
	public var loop(default, set):Bool;

	/**
	 * A callback that gets ran when
	 * this music has just finished.
	 */
	public var onComplete:Void->Void;

	public function new(music:BlissMusicAsset, ?volume:Float = 1, ?loop:Bool = true) {
		super();
		if(music is BlissMusic)
			this.music = music;
		else if(music is String)
			this.music = BlissMusic.fromFile(cast(music, String));

		this.music.useCount++;
		this.volume = volume;
		this.loop = loop;
	}

	override function update(elapsed:Float) {
		if(music == null)
			return;

		if(playing)
			Rl.updateMusicStream(music.music);

		if(!Rl.isMusicStreamPlaying(music.music) && playing && !paused && !loop)
			stop();
	}

	/**
	 * Plays this music.
	 */
	public function play(?forceRestart:Bool = false, ?startTime:Float = 0) {
	    if(music == null || (playing && !forceRestart))
			return this;

		playing = true;
		Rl.playMusicStream(music.music);
		Rl.setMusicVolume(music.music, volume);
		time = startTime;
		return this;
	}

	/**
	 * Stops this music.
	 */
	public function stop() {
        if(music == null)
            return this;

		playing = false;
        Rl.stopMusicStream(music.music);
		onComplete();
		return this;
	}

	/**
	 * Pauses this music.
	 */
	public function pause() {
        if(music == null)
            return this;

		paused = true;
		Rl.pauseMusicStream(music.music);
		return this;
	}

	/**
	 * Resumes this music.
	 */
	public function resume() {
        if(music == null)
            return this;

		paused = false;
		Rl.resumeMusicStream(music.music);
		return this;
	}

	@:noCompletion
	private var music:BlissMusic;

	@:noCompletion
	private function set_volume(v:Float):Float {
		if(music != null)
			Rl.setMusicVolume(music.music, v);

		return volume = v;
	}

	@:noCompletion
	private function set_pitch(v:Float):Float {
		if(music != null)
			Rl.setMusicPitch(music.music, v);

		return pitch = v;
	}

	@:noCompletion
	private function get_time():Float {
		return (music != null) ? Rl.getMusicTimePlayed(music.music) * 1000 : 0;
	}

	@:noCompletion
	private function set_time(v:Float):Float {
		if(music != null)
			Rl.seekMusicStream(music.music, v / 1000);

		return v;
	}

	@:noCompletion
	private function get_length():Float {
		var ret:Float = (music != null) ? (Rl.getMusicTimeLength(music.music) * 1000) : 0;
		if(ret < 0) ret = 0;
		return ret;
	}

	@:noCompletion
	private function set_loop(v:Bool):Bool {
		if(music != null)
			music.music.looping = v;

		return loop = v;
	}

	override function destroy() {
		music.useCount--;
		super.destroy();
	}
}
