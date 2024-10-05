module main;
import raylib5;
import vector;
import std::io;
import ws;


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
            ws::send_utf8_text(socket, "Hello from raylib");
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
    setup_websocket();

    emscripten_set_main_loop(&update, 60, 1);
    rl::closeWindow();
}

fn bool on_message(int eventType, ws::MessageEvent event, void* userData){
    rl::traceLog(rl::TraceLogLevel.DEBUG, "Message received");
    if (event.isText){
        rl::traceLog(rl::TraceLogLevel.DEBUG, string::tformat("Message: %s", (ZString) event.data));
    }
    return true;
    
}

fn bool on_open(int eventType,ws::OpenEvent event, void* userData){
    rl::traceLog(rl::TraceLogLevel.DEBUG, "Connection opened");
    Result res = ws::send_utf8_text(event.socket, "Hello from raylib");
    if(res){
        rl::traceLog(rl::TraceLogLevel.DEBUG, string::tformat("Error sending message: %d", res));
    }
    return true;
}

fn bool on_error(int eventType,ws::ErrorEvent event, void* userData){
    rl::traceLog(rl::TraceLogLevel.DEBUG, "Error occurred");
    return true;
}

fn bool on_close(int eventType,ws::CloseEvent event, void* userData){
    rl::traceLog(rl::TraceLogLevel.DEBUG, string::format("Connection closed with code: %d", event.code, allocator: allocator::heap()));
    return true;
}
ws::WebSocket socket;

fn void setup_websocket(){
    ws::CreateAttributes attributes = {
        .url = "wss://echo.websocket.events",
        .createOnMainThread = false
    };
    socket = ws::new(&attributes);
    ws::set_onmessage_callback(socket, null, &on_message);
    ws::set_onopen_callback(socket, null, &on_open);
    ws::set_onerror_callback(socket, null, &on_error);
    ws::set_onclose_callback(socket, null, &on_close);
    rl::traceLog(rl::TraceLogLevel.DEBUG, "Websocket created");
}