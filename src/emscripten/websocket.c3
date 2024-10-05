module ems::ws;
struct CreateAttributes @extern("EmscriptenWebSocketCreateAttributes") {
  // The target URL to connect to. This string can point to a stack local variable, the string is read immediately at a call to emscripten_websocket_new().
  char *url;
  // A comma-separated list of protocol strings. Set to e.g. "binary,base64" to create a WebSocket connection with two supported protocols "binary" and "base64".
  // Be careful to avoid leading and trailing spaces, e.g. "binary, base64" may not be interpreted properly.
  // This string can point to a stack local variable, the string is read immediately at a call to emscripten_websocket_new().
  char *protocols;

  // If true, the created socket will reside on the main browser thread. If false, the created socket is bound to the calling thread.
  // If you want to share the created EMSCRIPTEN_WEBSOCKET_T structure across multiple threads, or are running your own main loop in the
  // pthread that you create the socket, set createOnMainThread to true. If the created WebSocket only needs to be accessible on the thread
  // that created it, and the creating thread is an event based thread (meaning it regularly yields back to the browser event loop), then
  // it is more efficient to set this to false.
  bool createOnMainThread;
}


distinct WebSocket = int;
distinct Result = int;

// Creates a new WebSocket and connects it to the given remote host.
// If the return value of this function is > 0, the function has succeeded and the return value represents a handle to the WebSocket object.
// If the return value of this function is < 0, then the function has failed, and the return value can be interpreted as a EMSCRIPTEN_RESULT code
// representing the cause of the failure. If the function returns 0, then the call has failed with an unknown reason (build with -sWEBSOCKET_DEBUG for more information)
extern fn WebSocket new(CreateAttributes *createAttributes) @extern("emscripten_websocket_new");



struct OpenEvent @extern("EmscriptenWebSocketOpenEvent") {
  WebSocket socket;
}

def OpenCallback = fn bool(int eventType, OpenEvent, void*);

extern fn Result set_onopen_callback(WebSocket socket, void *userData, OpenCallback callback, ulong targetThread=0x02) @extern("emscripten_websocket_set_onopen_callback_on_thread");

struct MessageEvent @extern("EmscriptenWebSocketMessageEvent") {
  WebSocket socket;
  char* data;
  uint numBytes;
  bool isText;
}
def MessageCallback = fn bool(int eventType, MessageEvent, void*);
extern fn Result set_onmessage_callback(WebSocket socket, void *userData, MessageCallback callback, ulong targetThread=0x02) @extern("emscripten_websocket_set_onmessage_callback_on_thread");


struct ErrorEvent @extern("EmscriptenWebSocketErrorEvent") {
  WebSocket socket;
}
def ErrorCallback = fn bool(int eventType, ErrorEvent, void*);
extern fn Result set_onerror_callback(WebSocket socket, void *userData, ErrorCallback callback, ulong targetThread=0x02) @extern("emscripten_websocket_set_onerror_callback_on_thread");

struct CloseEvent @extern("EmscriptenWebSocketCloseEvent") {
  WebSocket socket;
  bool wasClean;
  ushort code;
  char[512] reason; // WebSockets spec enforces this can be max 123 characters, so as UTF-8 at most 123*4 bytes < 512.
}

def CloseCallback = fn bool(int eventType, CloseEvent, void*);
extern fn Result set_onclose_callback(WebSocket socket, void *userData, CloseCallback callback, ulong targetThread=0x02) @extern("emscripten_websocket_set_onclose_callback_on_thread");


// EMSCRIPTEN_RESULT emscripten_websocket_send_utf8_text(EMSCRIPTEN_WEBSOCKET_T socket, const char *textData __attribute__((nonnull)));
extern fn Result send_utf8_text(WebSocket socket, char* textData) @extern("emscripten_websocket_send_utf8_text");