module main;
import raylib5;
import vector;
import channel;
import std::io;


def Callback = fn void();


extern fn void emscripten_set_main_loop(Callback func, int fps, int simulate_infinite_loop) @if($feature(PLATFORM_WEB));

fn void emscripten_set_main_loop(Callback func, int fps, int simulate_infinite_loop) @if($feature(PLATFORM_DESKTOP)){
    rl::setTargetFPS(60);
    while (!rl::windowShouldClose())
    {
        func();
    }
}

struct RectState {
    rl::Vector2 position;
    rl::Vector2 size;
    rl::Color color;
    rl::Vector2 speed;
}

RectState rect = {
    .position = { 400.0f, 280.0f },
    .size = { 40, 40 },
    .color = rl::MAROON,
};


fn void update()
{
    rl::beginDrawing();

    rl::clearBackground(rl::RAYWHITE);

    key_handler();
    update_state();
    draw_state();

    rl::endDrawing();
}

fn void draw_state(){
    rl::drawRectangleV(rect.position, rect.size, rect.color);
}

fn void update_state(){
    rect.position.add(rect.speed);

    rect.position.clamp({0, 0}, {rl::getScreenWidth() - rect.size.x, rl::getScreenHeight() - rect.size.y});
}

fn void key_handler(){
    KeyboardKey key = (KeyboardKey) rl::getKeyPressed();
    switch(key){
        case rl::KEY_RIGHT:
            channel::send_text("Hello from raylib");
            rect.speed = {3.0f, 0.0f};
            break;
        case rl::KEY_LEFT:
            rect.speed = {-3.0f, 0.0f};
            break;
        case rl::KEY_UP:
            rect.speed = {0.0f, -3.0f};
            break;
        case rl::KEY_DOWN:
            rect.speed = {0.0f, 3.0f};
            break;  
    }
}


fn void main()
{
    rl::setTraceLogLevel(rl::TraceLogLevel.DEBUG);
    rl::initWindow(600, 600, "raylib [core] example - basic window");
    rl::traceLog(rl::TraceLogLevel.DEBUG, "Starting main loop");
    channel::init("wss://echo.websocket.org");

    emscripten_set_main_loop(&update, 60, 1);
    rl::closeWindow();
}
