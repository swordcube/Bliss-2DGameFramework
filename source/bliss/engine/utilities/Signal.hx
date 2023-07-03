package bliss.engine.utilities;

#if macro
import haxe.macro.Expr;
#else
/**
 * A simple signal class used for emitting several functions at once.
 */
typedef Signal = TypedSignal<Void->Void>;

/**
 * A simple typed signal class used for emitting several functions at once.
 * 
 * @see https://github.com/HaxeFlixel/flixel/blob/master/flixel/util/FlxSignal.hx
 */
@:multiType
abstract TypedSignal<T>(ISignal<T>) {
	public var emit(get, never):T;

	public function new();

	public inline function connect(listener:T, ?fireOnce:Bool = false):Void {
		this.connect(listener);
	}

	public inline function disconnect(listener:T):Void {
		this.disconnect(listener);
	}

	public inline function has(listener:T):Bool {
		return this.has(listener);
	}

	public inline function disconnectAll():Void {
		this.disconnectAll();
	}

	public inline function destroy():Void {
		this.destroy();
	}

	inline function get_emit():T {
		return this.emit;
	}

	@:to
	static inline function toSignal0(signal:ISignal<Void->Void>):Signal0 {
		return new Signal0();
	}

	@:to
	static inline function toSignal1<T1>(signal:ISignal<T1->Void>):Signal1<T1> {
		return new Signal1();
	}

	@:to
	static inline function toSignal2<T1, T2>(signal:ISignal<T1->T2->Void>):Signal2<T1, T2> {
		return new Signal2();
	}

	@:to
	static inline function toSignal3<T1, T2, T3>(signal:ISignal<T1->T2->T3->Void>):Signal3<T1, T2, T3> {
		return new Signal3();
	}

	@:to
	static inline function toSignal4<T1, T2, T3, T4>(signal:ISignal<T1->T2->T3->T4->Void>):Signal4<T1, T2, T3, T4> {
		return new Signal4();
	}
}

private class SignalHandler<T> {
	public var listener:T;
	public var emitOnce(default, null):Bool = false;

	public function new(listener:T, emitOnce:Bool) {
		this.listener = listener;
		this.emitOnce = emitOnce;
	}

	public function destroy() {
		listener = null;
	}
}

private class BaseSignal<T> implements ISignal<T> {
	/**
	 * Typed function reference used to emit this signal.
	 */
	public var emit:T;

	var handlers:Array<SignalHandler<T>>;
	var pendingRemove:Array<SignalHandler<T>>;
	var processingListeners:Bool = false;

	public function new() {
		handlers = [];
		pendingRemove = [];
	}

	public function connect(listener:T, ?emitOnce:Bool = false) {
		if (listener != null)
			registerListener(listener, emitOnce);
	}

	public function disconnect(listener:T):Void {
		if (listener != null) {
			var handler = getHandler(listener);
			if (handler != null) {
				if (processingListeners)
					pendingRemove.push(handler);
				else {
					handlers.remove(handler);
					handler.destroy();
				}
			}
		}
	}

	public function has(listener:T):Bool {
		if (listener == null)
			return false;
		return getHandler(listener) != null;
	}

	public inline function disconnectAll():Void {
		handlers = [];
	}

	public function destroy():Void {
		handlers = null;
		pendingRemove = null;
	}

	private function registerListener(listener:T, emitOnce:Bool):SignalHandler<T> {
		var handler = getHandler(listener);

		if (handler == null) {
			handler = new SignalHandler<T>(listener, emitOnce);
			handlers.push(handler);
			return handler;
		} else {
			// If the listener was previously added, definitely don't add it again.
			// But throw an exception if their once values differ.
			if (handler.emitOnce != emitOnce)
				throw "You cannot connect(listener, true) then connect(listener) the same listener without removing the relationship first.";
			else
				return handler;
		}
	}

	private function getHandler(listener:T):SignalHandler<T> {
		for(handler in handlers) {
			if(Reflect.compareMethods(handler.listener, listener)) {
				return handler; // Listener was already registered.
			}
		}
		return null; // Listener not yet registered.
	}
}

private class Signal0 extends BaseSignal<Void->Void> {
	public function new() {
		super();
		this.emit = emit0;
	}

	public function emit0():Void {
		Macro.buildEmit();
	}
}

private class Signal1<T1> extends BaseSignal<T1->Void> {
	public function new() {
		super();
		this.emit = emit1;
	}

	public function emit1(value1:T1):Void {
		Macro.buildEmit(value1);
	}
}

private class Signal2<T1, T2> extends BaseSignal<T1->T2->Void> {
	public function new() {
		super();
		this.emit = emit2;
	}

	public function emit2(value1:T1, value2:T2):Void {
		Macro.buildEmit(value1, value2);
	}
}

private class Signal3<T1, T2, T3> extends BaseSignal<T1->T2->T3->Void> {
	public function new() {
		super();
		this.emit = emit3;
	}

	public function emit3(value1:T1, value2:T2, value3:T3):Void {
		Macro.buildEmit(value1, value2, value3);
	}
}

private class Signal4<T1, T2, T3, T4> extends BaseSignal<T1->T2->T3->T4->Void> {
	public function new() {
		super();
		this.emit = emit4;
	}

	public function emit4(value1:T1, value2:T2, value3:T3, value4:T4):Void {
		Macro.buildEmit(value1, value2, value3, value4);
	}
}

interface ISignal<T> {
	var emit:T;
	function connect(listener:T, ?fireOnce:Bool = false):Void;
	function disconnect(listener:T):Void;
	function disconnectAll():Void;
	function destroy():Void;
	function has(listener:T):Bool;
}
#end

private class Macro {
	public static macro function buildEmit(exprs:Array<Expr>):Expr {
		return macro {
			processingListeners = true;
			for(handler in handlers) {
				handler.listener($a{exprs});

				if(handler.emitOnce)
					disconnect(handler.listener);
			}

			processingListeners = false;

			for (handler in pendingRemove)
				disconnect(handler.listener);
			
			if (pendingRemove.length > 0)
				pendingRemove = [];
		}
	}
}
