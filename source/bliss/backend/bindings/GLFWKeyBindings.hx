package bliss.backend.bindings;

@:include("external/glfw/include/GLFW/glfw3.h")
@:native("GLFWwindow")
@:structAccess
extern class GLFWWindowStruct {}

typedef GlfwWindow = cpp.RawPointer<GLFWWindowStruct>;

typedef GlfwKeyFunc = cpp.Callable<(window:GlfwWindow, key:Int, scancode:Int, action:Int, mods:Int) -> Void>;

@:include("external/glfw/include/GLFW/glfw3.h")
extern class GLFWKeyBindings {
    @:native("glfwSetKeyCallback")
    public static function setKeyCallback(window:GlfwWindow, callback:GlfwKeyFunc):GlfwKeyFunc;

    @:native("glfwGetCurrentContext")
    public static function getCurrentContext():GlfwWindow;
}