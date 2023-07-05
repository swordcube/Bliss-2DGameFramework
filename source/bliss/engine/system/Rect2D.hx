package bliss.engine.system;

abstract Rect2D(Array<Float>) from Array<Float> to Array<Float> {
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var w(get, set):Float;
    public var h(get, set):Float;

    public function new(x:Float, y:Float, w:Float, h:Float) {
        set(x, y, w, h);
    }

    public inline function set(x:Float, y:Float, w:Float, h:Float) {
        this = [x, y, w, h];
    }

    public inline function add(x:Float, y:Float, w:Float, h:Float) {
        this[0] += x;
        this[1] += y;
        this[2] += w;
        this[3] += h;
    }

    public inline function subtract(x:Float, y:Float, w:Float, h:Float) {
        this[0] -= x;
        this[1] -= y;
        this[2] -= w;
        this[3] -= h;
    }

    public inline function multiply(x:Float, y:Float, w:Float, h:Float) {
        this[0] *= x;
        this[1] *= y;
        this[2] *= w;
        this[3] *= h;
    }

    public inline function divide(x:Float, y:Float, w:Float, h:Float) {
        this[0] /= x;
        this[1] /= y;
        this[2] /= w;
        this[3] /= h;
    }

    /**
     * Sets this rectangle's values to those of another rectangle.
     * @param rect The rectangle to copy.
     */
    public inline function copyFrom(rect:Rect2D) {
        set(rect.x, rect.y, rect.w, rect.h);
    }

    /**
     * Converts a Raylib `Rectangle` and turns it into a Droplet `Rect2D`.
     * @param vector The Raylib `Rectangle` to convert.
     */
    public static inline function fromRaylib(rect:Rl.Rectangle) {
        return new Rect2D(rect.x, rect.y, rect.width, rect.height);
    }

    /**
     * Converts this Droplet `Rect2D` into a Raylib `Rectangle`.
     */
    public inline function toRaylib() {
        return Rl.Rectangle.create(x, y, w, h);
    }

    @:noCompletion
    private inline function get_x():Float {
        return this[0];
    }

    @:noCompletion
    private inline function set_x(v:Float):Float {
        return this[0] = v;
    }

    @:noCompletion
    private inline function get_y():Float {
        return this[1];
    }

    @:noCompletion
    private inline function set_y(v:Float):Float {
        return this[1] = v;
    }

    @:noCompletion
    private inline function get_w():Float {
        return this[2];
    }

    @:noCompletion
    private inline function set_w(v:Float):Float {
        return this[2] = v;
    }

    @:noCompletion
    private inline function get_h():Float {
        return this[3];
    }

    @:noCompletion
    private inline function set_h(v:Float):Float {
        return this[3] = v;
    }

    @:noCompletion
    @:op(A + B)
    private static inline function addOp(a:Rect2D, b:Rect2D) {
        return new Rect2D(
            a.x + b.x,
            a.y + b.y,
            a.w + b.w,
            a.h + b.h
        );
    }

    @:noCompletion
    @:op(A - B)
    private static inline function subtractOp(a:Rect2D, b:Rect2D) {
        return new Rect2D(
            a.x - b.x,
            a.y - b.y,
            a.w - b.w,
            a.h - b.h
        );
    }

    @:noCompletion
    @:op(A * B)
    private static inline function multiplyOp(a:Rect2D, b:Rect2D) {
        return new Rect2D(
            a.x * b.x,
            a.y * b.y,
            a.w * b.w,
            a.h * b.h
        );
    }

    @:noCompletion
    @:op(A / B)
    private static inline function divideOp(a:Rect2D, b:Rect2D) {
        return new Rect2D(
            a.x / b.x,
            a.y / b.y,
            a.w / b.w,
            a.h / b.h
        );
    }
}