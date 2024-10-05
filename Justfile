OUTPUT_DIR := "docs"

compile:
    c3c static-lib --lib raylib5 -D PLATFORM_WEB --reloc=none --target wasm32 -O1 -g0 --link-libc=yes --use-stdlib=yes -o {{OUTPUT_DIR}}/demo main.c3

link: compile
    emcc {{OUTPUT_DIR}}/demo.a -O1 ./libraylib.a  -s USE_GLFW=3 -s ASYNCIFY -DPLATFORM_WEB -o {{OUTPUT_DIR}}/app.html --shell-file shell.html
    mv {{OUTPUT_DIR}}/app.html {{OUTPUT_DIR}}/index.html

run: link
    browser-sync start --files "{{OUTPUT_DIR}}/index.html" --server "{{OUTPUT_DIR}}" --port 8080


compile-desktop:
    c3c compile  -D PLATFORM_DESKTOP --lib raylib5 -O1 -g0 --link-libc=yes --use-stdlib=yes -o demo main.c3

run-desktop: compile-desktop
    ./demo