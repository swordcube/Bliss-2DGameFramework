package bliss.managers;

import bliss.engine.Scene;
import bliss.engine.utilities.Signal;

class SignalManager {
    /**
     * Called right before the current scene's
     * `create()` function is called.
     */
    public var preSceneCreate:TypedSignal<Scene->Void> = new TypedSignal();

    /**
     * Called right after the current scene's
     * `create()` function is called.
     */
    public var postSceneCreate:TypedSignal<Scene->Void> = new TypedSignal();

    /**
     * Called right before the current scene updates.
     */
    public var preSceneUpdate:TypedSignal<Scene->Void> = new TypedSignal();

    /**
     * Called right after the current scene updates.
     */
    public var postSceneUpdate:TypedSignal<Scene->Void> = new TypedSignal();

    /**
     * Called right before the current scene renders to the window.
     */
    public var preSceneRender:TypedSignal<Scene->Void> = new TypedSignal();

    /**
     * Called right after the current scene renders to the window.
     */
    public var postSceneRender:TypedSignal<Scene->Void> = new TypedSignal();
    
    /**
     * Called right before the current scene is destroyed.
     */
    public var preSceneDestroy:TypedSignal<Scene->Void> = new TypedSignal();

    /**
     * Called right after the current scene is destroyed.
     */
    public var postSceneDestroy:TypedSignal<Scene->Void> = new TypedSignal();
    
    public function new() {}
}