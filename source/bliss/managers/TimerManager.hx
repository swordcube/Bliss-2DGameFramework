package bliss.managers;

import bliss.backend.Debug;
import bliss.engine.system.Game;
import bliss.engine.utilities.BlissTimer;

class TimerManager {
    public var list:Array<BlissTimer> = [];

    public function new() {
        Game.signals.preSceneUpdate.connect((_) -> {
            final elapsed:Float = Game.elapsed;
            for(timer in list)
                timer.update(elapsed);
        });

        Game.signals.preSceneCreate.connect((_) -> {
            for(timer in list) {
                timer.kill();
                timer.stop();
                timer.destroy();
            }
            list = [];
        });
    }

    /**
     * Adds a timer to the list of updating timers.
     * 
     * @param timer  The timer to add.
     */
    public function add(timer:BlissTimer) {
        if(list.contains(timer)) {
			Debug.log(WARNING, "Cannot add an timer that was already added to this TimerManager!");
			return timer;
		}
        list.push(timer);
        return timer;
    }

    /**
     * Removes a timer from the list of updating timers.
     * 
     * @param timer  The timer to remove.
     */
    public function remove(timer:BlissTimer) {
        if(!list.contains(timer)) {
			Debug.log(WARNING, "Cannot remove an timer that wasn't added to this TimerManager!");
			return timer;
		}
        list.remove(timer);
        return timer;
    }
}