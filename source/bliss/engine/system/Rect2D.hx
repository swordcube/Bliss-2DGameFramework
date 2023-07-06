package bliss.engine.system;

@:forward abstract Rect2D(BaseRect2D) to BaseRect2D from BaseRect2D {
    public function new(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0) {
        this = new BaseRect2D(x, y, w, h);
    }

    //##-- VARIABLES/FUNCTIONS YOU NORMALLY SHOULDN'T HAVE TO TOUCH!! --##//
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
    @:op(A += B)
    private static inline function addEqualOp(a:Rect2D, b:Rect2D) {
        return a.add(
            b.x,
            b.y,
            b.w,
            b.h
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
    @:op(A -= B)
    private static inline function subtractEqualOp(a:Rect2D, b:Rect2D) {
        return a.subtract(
            b.x,
            b.y,
            b.w,
            b.h
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
    @:op(A *= B)
    private static inline function multiplyEqualOp(a:Rect2D, b:Rect2D) {
        return a.multiply(
            b.x,
            b.y,
            b.w,
            b.h
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

    @:noCompletion
    @:op(A /= B)
    private static inline function divideEqualOp(a:Rect2D, b:Rect2D) {
        return a.divide(
            b.x,
            b.y,
            b.w,
            b.h
        );
    }
}

class BaseRect2D {
    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;

    public function new(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0) {
        set(x, y, w, h);
    }

    public inline function set(x:Float, y:Float, w:Float, h:Float) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        return this;
    }

    public inline function add(x:Float, y:Float, w:Float, h:Float) {
        this.x += x;
        this.y += y;
        this.w += w;
        this.h += h;
        return this;
    }

    public inline function subtract(x:Float, y:Float, w:Float, h:Float) {
        this.x -= x;
        this.y -= y;
        this.w -= w;
        this.h -= h;
        return this;
    }

    public inline function multiply(x:Float, y:Float, w:Float, h:Float) {
        this.x *= x;
        this.y *= y;
        this.w *= w;
        this.h *= h;
        return this;
    }

    public inline function divide(x:Float, y:Float, w:Float, h:Float) {
        this.x /= x;
        this.y /= y;
        this.w /= w;
        this.h /= h;
        return this;
    }

    /**
     * Sets this rectangle's values to those of another rectangle.
     * @param rect The rectangle to copy.
     */
    public inline function copyFrom(rect:Rect2D) {
        set(rect.x, rect.y, rect.w, rect.h);
    }

    /**
     * Converts a Raylib `Rectangle` and turns it into a Bliss `Rect2D`.
     * @param vector The Raylib `Rectangle` to convert.
     */
    public static inline function fromRaylib(rect:Rl.Rectangle) {
        return new Rect2D(rect.x, rect.y, rect.width, rect.height);
    }

    /**
     * Converts this Bliss `Rect2D` into a Raylib `Rectangle`.
     */
    public inline function toRaylib() {
        return Rl.Rectangle.create(x, y, w, h);
    }

    /**
     * Makes every value in this vector positive.
     */
    public inline function abs() {
        x = Math.abs(x);
        y = Math.abs(y);
        w = Math.abs(w);
        h = Math.abs(h);
        return this;
    }
}