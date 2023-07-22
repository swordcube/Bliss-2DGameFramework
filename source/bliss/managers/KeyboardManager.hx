package bliss.managers;

import bliss.backend.bindings.GLFWBindings;
import bliss.backend.input.InputState;
import bliss.backend.input.Keys;

import bliss.engine.system.Game;
import bliss.engine.utilities.Signal;

using bliss.engine.utilities.ArrayUtil;

/**
 * A helper class to make keyboard input easier to code.
 */
class KeyboardManager {
    /**
     * A signal that gets ran as soon as a key
     * was just pressed.
     */
    public var onKeyPress:TypedSignal<Keys->Void> = new TypedSignal();

    /**
     * A signal that gets ran as soon as a key
     * was just released.
     */
    public var onKeyRelease:TypedSignal<Keys->Void> = new TypedSignal();

    public var justPressed(get, never):Keys->Bool;
    public var pressed(get, never):Keys->Bool;

    public var justReleased(get, never):Keys->Bool;
    public var released(get, never):Keys->Bool;

    public var anyJustPressed(get, never):(Array<Keys>)->Bool;
    public var anyPressed(get, never):(Array<Keys>)->Bool;
    public var anyJustReleased(get, never):(Array<Keys>)->Bool;
    public var anyReleased(get, never):(Array<Keys>)->Bool;

    public function new() {
        _glfwKeyCallback = GLFWBindings.setKeyCallback(GLFWBindings.getCurrentContext(), cpp.Callable.fromStaticFunction(_keyCallback));
    }
    
    public function update(elapsed:Float) {
        for(callback in _postUpdateCallbacks)
            callback();

        _postUpdateCallbacks.clearArray();
    }
    
    //##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
    @:noCompletion
    private inline function get_justPressed() {
        return (key:Keys) -> {
            @:privateAccess
            return (key == Keys.ANY) ? getStatusOfAnyKey(JUST_PRESSED) : (_keyStatuses.get(key) == JUST_PRESSED);
        };
    }

    @:noCompletion
    private inline function get_pressed() {
        return (key:Keys) -> {
            @:privateAccess
            return (key == Keys.ANY) ? getStatusOfAnyKey(PRESSED) : (_keyStatuses.get(key) == JUST_PRESSED || _keyStatuses.get(key) == PRESSED);
        };
    }

    @:noCompletion
    private inline function get_justReleased() {
        return (key:Keys) -> {
            @:privateAccess
            return (key == Keys.ANY) ? getStatusOfAnyKey(JUST_RELEASED) : (_keyStatuses.get(key) == JUST_RELEASED);
        };
    }

    @:noCompletion
    private inline function get_released() {
        return (key:Keys) -> {
            @:privateAccess
            return (key == Keys.ANY) ? getStatusOfAnyKey(RELEASED) : (_keyStatuses.get(key) == JUST_RELEASED || _keyStatuses.get(key) == RELEASED);
        };
    }

    @:noCompletion
    private inline function get_anyJustPressed() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if(justPressed(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private inline function get_anyPressed() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if(pressed(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private inline function get_anyJustReleased() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if(justReleased(key))
                    return true;
            }
            return false;
        };
    }

    @:noCompletion
    private inline function get_anyReleased() {
        return (keys:Array<Keys>) -> {
            for(key in keys) {
                if(released(key))
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

    @:noCompletion
    private var _postUpdateCallbacks:Array<Void->Void> = [];

    @:noCompletion
    public static var _glfwKeyCallback:GlfwKeyFunc;

    @:noCompletion
    public static var _keyStatuses:Map<Keys, InputState> = [];

    @:noCompletion
    private static function _keyCallback(window:GlfwWindow, key:Int, scancode:Int, action:Int, mods:Int):Void {
        _glfwKeyCallback.call(window, key, scancode, action, mods);

        switch(action) {
            case GLFWBindings.ACTION_PRESS:
                _keyStatuses.set(key, JUST_PRESSED);
                Game.keys.onKeyPress.emit(key);
                
                @:privateAccess
                Game.keys._postUpdateCallbacks.push(() -> _keyStatuses.set(key, PRESSED));
                
            case GLFWBindings.ACTION_RELEASE:
                _keyStatuses.set(key, JUST_RELEASED);
                Game.keys.onKeyRelease.emit(key);
                    
                @:privateAccess
                Game.keys._postUpdateCallbacks.push(() -> _keyStatuses.set(key, RELEASED));
        }
    }
}