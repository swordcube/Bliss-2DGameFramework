package bliss.backend.input;

enum abstract InputState(Int) from Int to Int {
    var JUST_PRESSED = 0;
    var PRESSED = 1;
    var JUST_RELEASED = 2;
    var RELEASED = 3;
}