package bliss.engine.system;

abstract Vector2D(Array<Float>) from Array<Float> to Array<Float> {
    public var x(get, set):Float;
    public var y(get, set):Float;

    public function new(x:Float, y:Float) {
        set(x, y);
    }

    public inline function set(x:Float, y:Float) {
        this = [x, y];
    }

    public inline function add(x:Float, y:Float) {
        this[0] += x;
        this[1] += y;
    }

    public inline function subtract(x:Float, y:Float) {
        this[0] -= x;
        this[1] -= y;
    }

    public inline function multiply(x:Float, y:Float) {
        this[0] *= x;
        this[1] *= y;
    }

    public inline function divide(x:Float, y:Float) {
        this[0] /= x;
        this[1] /= y;
    }

    /**
     * Sets this vector's values to those of another vector.
     * @param vector The vector to copy.
     */
    public inline function copyFrom(vector:Vector2D) {
        set(vector.x, vector.y);
    }

    /**
     * Converts a Raylib `Vector2` and turns it into a Droplet `Vector2D`.
     * @param vector The Raylib `Vector2` to convert.
     */
    public static inline function fromRaylib(vector:Rl.Vector2) {
        return new Vector2D(vector.x, vector.y);
    }

    /**
     * Converts this Droplet `Vector2D` into a Raylib `Vector2`.
     */
    public inline function toRaylib() {
        return Rl.Vector2.create(x, y);
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
    @:op(A + B)
    private static inline function addOp(a:Vector2D, b:Vector2D) {
        return new Vector2D(
            a.x + b.x,
            a.y + b.y
        );
    }

    @:noCompletion
    @:op(A - B)
    private static inline function subtractOp(a:Vector2D, b:Vector2D) {
        return new Vector2D(
            a.x - b.x,
            a.y - b.y
        );
    }

    @:noCompletion
    @:op(A * B)
    private static inline function multiplyOp(a:Vector2D, b:Vector2D) {
        return new Vector2D(
            a.x * b.x,
            a.y * b.y
        );
    }

    @:noCompletion
    @:op(A / B)
    private static inline function divideOp(a:Vector2D, b:Vector2D) {
        return new Vector2D(
            a.x / b.x,
            a.y / b.y
        );
    }
}