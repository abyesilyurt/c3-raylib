module main;
import raylib5;
import std::io;

def Callback = fn void();
extern fn void emscripten_set_main_loop(Callback func, int fps, int simulate_infinite_loop);


fn void update()
{
    rl::beginDrawing();

    rl::clearBackground(rl::RAYWHITE);

    rl::drawText("Congrats! You created your first window!", 190, 200, 20, rl::LIGHTGRAY);

    rl::endDrawing();
}
fn void main() @export("_start")
{
    rl::setTraceLogLevel(rl::TraceLogLevel.WARNING);
    io::printfn("Tadaaaa");
    rl::initWindow(800, 450, "raylib [core] example - basic window");
    emscripten_set_main_loop(&update, 0, 1);
    rl::closeWindow();
}
