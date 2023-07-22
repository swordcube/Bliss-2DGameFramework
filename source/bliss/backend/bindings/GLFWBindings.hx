package bliss.backend.bindings;

#if !macro
@:include("external/glfw/include/GLFW/glfw3.h")
@:native("GLFWwindow")
@:structAccess
extern class GLFWWindowStruct {}

typedef GlfwWindow = cpp.RawPointer<GLFWWindowStruct>;

typedef GlfwKeyFunc = cpp.Callable<(window:GlfwWindow, key:Int, scancode:Int, action:Int, mods:Int) -> Void>;

@:include("external/glfw/include/GLFW/glfw3.h")
/**
 * This class does not have all of the bindings for
 * GLFW, and is here for more responsive input.
 */
extern class GLFWBindings {
    @:native("GLFW_PRESS")
    public static final ACTION_PRESS:Int;

    @:native("GLFW_RELEASE")
    public static final ACTION_RELEASE:Int;

    @:native("GLFW_REPEAT")
    public static final ACTION_REPEAT:Int;

    @:native("glfwSetKeyCallback")
    public static function setKeyCallback(window:GlfwWindow, callback:GlfwKeyFunc):GlfwKeyFunc;

    @:native("glfwGetCurrentContext")
    public static function getCurrentContext():GlfwWindow;
}
#end