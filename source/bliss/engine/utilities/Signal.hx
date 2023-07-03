package bliss.engine.utilities;

// TODO: document this class
class Signal<T> {
	public var listeners:Array<T->Void> = [];

	public inline function connect(listener:T->Void) {
		if(listeners.contains(listener)) return;
		listeners.push(listener);
	}

	public inline function disconnect(listener:T->Void) {
		if(!listeners.contains(listener)) return;
		listeners.remove(listener);
	}

	public inline function removeAll() {
		listeners = [];
	}

	public inline function emit(arg:T) {
		for(listener in listeners)
			listener(arg);
	}

	public inline function new() {}
}