package bliss.managers;

import bliss.backend.Application;
import sys.thread.Thread;
import bliss.backend.sound.BlissMusic.BlissMusicAsset;
import bliss.backend.sound.BlissSound;
import bliss.backend.Debug;
import bliss.backend.interfaces.ISound;

import bliss.engine.system.Game;
import bliss.engine.sound.MusicPlayer;
import bliss.engine.sound.SoundPlayer;

using bliss.engine.utilities.ArrayUtil;

class SoundManager {
    /**
     * The currently playing music.
     */
    public var music:MusicPlayer;

    /**
     * A multiplier to every playing sound's volume.
     */
    public var volume(default, set):Float = 1;

    /**
     * Whether or not sounds can play.
     */
    public var muted(default, set):Bool = false;
    
    /**
     * The list of every currently playing sound/music.
     */
    public var list:Array<ISound> = [];

    /**
	 * Returns a stored sound from a specified key.
	 * 
	 * @param key Key for the sound (its name).
	 */
	public inline function get(key:String) {
		return _cache.get(key);
	}

	/**
	 * Returns whether or not a sound with a specified key
	 * can be found in the cache.
	 *
	 * @param key The key identifying the sound.
	 */
	public inline function isCached(key:String) {
		return _cache.exists(key);
	}

	/**
	 * Caches any specified sound.
	 *
	 * @param	Sound to store in the cache.
	 */
	public inline function cacheSound(sound:BlissSound):BlissSound {
		_cache.set(sound.key, sound);
		return sound;
	}

    /**
	 * Destroys each sound in cache.
	 */
	public inline function clear() {
		for(asset in _cache)
			asset.destroy();
		_cache.clear();
	}
    
    public function new() {
        Rl.initAudioDevice();
        volume = 0.3;
        
        Game.signals.preSceneCreate.connect((_) -> {
            for(sound in list) {
                sound.stop();
                sound.destroy();
                sound = null;
            }
            list.clearArray();
        });

        // TODO: make audio not pause when a state switch occurs
        // Thread.create(() -> {
        //     final app = Application.self;
        //     while(app.running)
        //         update();
        // });
        Game.signals.preSceneUpdate.connect((_) -> update());
    }

    /**
     * Plays any specified sound asset.
     * 
     * @param asset   The sound asset to play.
     * @param volume  The volume of this sound.
     */
    public function play(asset:BlissSoundAsset, ?volume:Float) {
        list.push(new SoundPlayer(asset, volume).play());
    }

    /**
     * Plays any specified music asset.
     * 
     * @param asset   The music asset to play.
     * @param volume  The volume of this music.
     */
    public function playMusic(asset:BlissMusicAsset, ?volume:Float, ?loop:Bool = true) {
		if(music != null)
			music.destroy();

		music = new MusicPlayer(asset, volume).play();
        music.loop = loop;
	}

    @:noCompletion
    private function set_volume(v:Float) {
        Rl.setMasterVolume(v);
        return volume = v;
    }

    @:noCompletion
    private function set_muted(v:Bool) {
        Rl.setMasterVolume((v) ? 0 : volume);
        return muted = v;
    }

    @:noCompletion
    private function update() {
        final elapsed = Game.elapsed;

        for(sound in list) {
            @:privateAccess
            if(sound != null && !sound.updating)
                sound.update(elapsed);
        }
        
        @:privateAccess
        if(music != null && !music.updating)
            music.update(elapsed);
    }

    @:noCompletion
	private var _cache:Map<String, BlissSound> = [];
}