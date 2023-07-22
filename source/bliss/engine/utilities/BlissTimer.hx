package bliss.engine.utilities;

import bliss.engine.system.Game;
import bliss.managers.TimerManager;

class BlissTimer extends Object {
    public var finishCallback:BlissTimer->Void;

    public var loops:Int = 0;
    public var loopsLeft:Int = 0;
    
    public var duration:Float = 0;

    public function new(?manager:TimerManager) {
        super();
        if(manager != null)
            this.manager = manager;
        else
            this.manager = Game.timers;

        this.manager.add(this);
    }

    /**
     * Starts this timer
     * .
     * @param duration        The duration of the timer.
     * @param finishCallback  The function that runs when the timer loops/finishes
     * @param loops           The amount of times the timer runs. 0 is infinite.
     */
    public function start(duration:Float, ?finishCallback:BlissTimer->Void, ?loops:Int = 1) {
        this.duration = duration;
        this.finishCallback = finishCallback;
        this.loops = this.loopsLeft = loops;
        this.active = true;
        return this;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(!active) return;

        _elapsedTime += elapsed;

        if(_elapsedTime >= duration) {
            _elapsedTime = 0;
            
            if(loops <= 0) {
                if(finishCallback != null)
                    finishCallback(this);
            } else {
                loopsLeft--;
                if(loopsLeft <= 0) {
                    if(finishCallback != null)
                        finishCallback(this);

                    stop();
                    destroy();
                } else {
                    if(finishCallback != null)
                        finishCallback(this);
                }
            }
        }
    }

    /**
     * Resumes this timer.
     */
    public function resume() {
        active = true;
    }

    /**
     * Pauses this timer.
     */
    public function pause() {
        active = false;
    }

    /**
     * Stops this timer.
     */
    public inline function stop() {pause();}

    override function destroy() {
        if(manager != null)
            manager.remove(this);

        active = false;

        super.destroy();
    }

    @:noCompletion
    private var _elapsedTime:Float = 0;

    @:noCompletion
    private var manager:TimerManager;
}