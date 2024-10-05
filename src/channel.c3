module channel;
import ems::ws;
import raylib5;

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

fn void init(String url){
    ws::CreateAttributes attributes = {
        .url = url,
        .createOnMainThread = false
    };
    socket = ems::ws::new(&attributes);
    ws::set_onmessage_callback(socket, null, &on_message);
    ws::set_onopen_callback(socket, null, &on_open);
    ws::set_onerror_callback(socket, null, &on_error);
    ws::set_onclose_callback(socket, null, &on_close);
    rl::traceLog(rl::TraceLogLevel.DEBUG, "Websocket created");
}

ws::WebSocket socket;


fn void send_text(String text){
    ws::send_utf8_text(socket, text);
}