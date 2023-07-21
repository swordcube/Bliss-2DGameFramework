package bliss.managers;

import bliss.backend.input.Keys;

/**
 * A helper class to make keyboard input easier to code.
 */
class KeyboardManager {
    public var justPressed(get, never):Keys->Bool;
    public var pressed(get, never):Keys->Bool;

    public var justReleased(get, never):Keys->Bool;
    public var released(get, never):Keys->Bool;

    public var anyJustPressed(get, never):(Array<Keys>)->Bool;
    public var anyPressed(get, never):(Array<Keys>)->Bool;
    public var anyJustReleased(get, never):(Array<Keys>)->Bool;
    public var anyReleased(get, never):(Array<Keys>)->Bool;

    //##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
    @:noCompletion
    private inline function get_justPressed() {
        return (key:Keys) -> {
            return (key == Keys.ANY) ? getStatusOfAnyKey(JUST_PRESSED) : Rl.isKeyPressed(key);
        };
    }

    @:noCompletion
    private inline function get_pressed() {
        return (key:Keys) -> {
            return (key == Keys.ANY) ? getStatusOfAnyKey(PRESSED) : Rl.isKeyDown(key);
        };
    }

    @:noCompletion
    private inline function get_justReleased() {
        return (key:Keys) -> {
            return (key == Keys.ANY) ? getStatusOfAnyKey(JUST_RELEASED) : Rl.isKeyReleased(key);
        };
    }

    @:noCompletion
    private inline function get_released() {
        return (key:Keys) -> {
            return (key == Keys.ANY) ? getStatusOfAnyKey(RELEASED) : Rl.isKeyUp(key);
        };
    }

    @:noCompletion
    private inline function get_anyJustPressed() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if((key == Keys.ANY) ? getStatusOfAnyKey(JUST_PRESSED) : Rl.isKeyPressed(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private inline function get_anyPressed() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if((key == Keys.ANY) ? getStatusOfAnyKey(PRESSED) : Rl.isKeyDown(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private inline function get_anyJustReleased() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if((key == Keys.ANY) ? getStatusOfAnyKey(JUST_RELEASED) : Rl.isKeyReleased(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private inline function get_anyReleased() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if((key == Keys.ANY) ? getStatusOfAnyKey(RELEASED) : Rl.isKeyUp(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private function getStatusOfAnyKey(status:KeyState) {
        for(key in Keys.toStringMap.keys()) {
            if(key == ANY) continue;

            switch(status) {
                case JUST_PRESSED: if(justPressed(key)) return true;
                case PRESSED: if(pressed(key)) return true;
                case JUST_RELEASED: if(justReleased(key)) return true;
                case RELEASED: if(released(key)) return true;
            }
        }
        return false;
    }

    public function new() {}
}