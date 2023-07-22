package bliss.engine.system;

@:forward abstract Vector2D(BaseVector2D) to BaseVector2D from BaseVector2D {
    public static var ZERO(default, never):Vector2D = new Vector2D(0, 0);

    public inline function new(x:Float = 0, y:Float = 0) {
        this = new BaseVector2D(x, y);
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
    @:op(A += B)
    private static inline function addEqualOp(a:Vector2D, b:Vector2D) {
        return a.add(
            b.x,
            b.y
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
    @:op(A -= B)
    private static inline function subtractEqualOp(a:Vector2D, b:Vector2D) {
        return a.subtract(
            b.x,
            b.y
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
    @:op(A *= B)
    private static inline function multiplyEqualOp(a:Vector2D, b:Vector2D) {
        return a.multiply(
            b.x,
            b.y
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

    @:noCompletion
    @:op(A /= B)
    private static inline function divideEqualOp(a:Vector2D, b:Vector2D) {
        return a.divide(
            b.x,
            b.y
        );
    }
}

class BaseVector2D {
    public var x:Float;
    public var y:Float;

    public function new(x:Float = 0, y:Float = 0) {
        set(x, y);
    }

    /**
     * Set the coordinates of this point object.
     *
     * @param x The X-coordinate of the point in space.
     * @param y The Y-coordinate of the point in space.
     */
    public inline function set(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
        return this;
    }

    /**
     * Adds to the coordinates of this point.
     *
     * @param x Amount to add to x
     * @param y Amount to add to y
     */
    public inline function add(x:Float = 0, y:Float = 0) {
        this.x += x;
        this.y += y;
        return this;
    }

    /**
     * Subtracts from the coordinates of this point.
     *
     * @param x Amount to subtract from x
     * @param y Amount to subtract from y
     */
    public inline function subtract(x:Float = 0, y:Float = 0) {
        this.x -= x;
        this.y -= y;
        return this;
    }

    /**
     * Multiplies the coordinates of this point.
     *
     * @param x Amount to multiply to x
     * @param y Amount to multiply to y
     */
    public inline function multiply(x:Float = 0, y:Float = 0) {
        this.x *= x;
        this.y *= y;
        return this;
    }

    /**
     * Divides the coordinates of this point.
     *
     * @param x Amount to divide from x
     * @param y Amount to divide from y
     */
    public inline function divide(x:Float = 0, y:Float = 0) {
        this.x /= x;
        this.y /= y;
        return this;
    }

    /**
     * Sets this vector's values to those of another vector.
     * 
     * @param vector The vector to copy.
     */
    public inline function copyFrom(vector:Vector2D) {
        return set(vector.x, vector.y);
    }

    /**
     * Converts a Raylib `Vector2` and turns it into a Bliss `Vector2D`.
     * 
     * @param vector The Raylib `Vector2` to convert.
     */
    public static inline function fromRaylib(vector:Rl.Vector2) {
        return new Vector2D(vector.x, vector.y);
    }
    
    /**
     * Converts this Bliss `Vector2D` into a Raylib `Vector2`.
     */
    public inline function toRaylib() {
        return Rl.Vector2.create(x, y);
    }
    
    /**
     * Makes every value in this vector positive.
     */
    public inline function abs() {
        x = Math.abs(x);
        y = Math.abs(y);
        return this;
    }
}