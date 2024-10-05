OUTPUT_DIR := "output"

compile:
    c3c static-lib -D PLATFORM_WEB --reloc=none --target wasm32 -O1 -g0 --link-libc=yes --use-stdlib=yes -o {{OUTPUT_DIR}}/demo main.c3 raylib5.c3i

link: compile
    emcc {{OUTPUT_DIR}}/demo.a -O1 ./libraylib.a  -s USE_GLFW=3 -s ASYNCIFY -DPLATFORM_WEB -o {{OUTPUT_DIR}}/app.html --shell-file shell.html
    mv {{OUTPUT_DIR}}/app.html {{OUTPUT_DIR}}/index.html

run: link
    emrun --no_browser --port 8080 {{OUTPUT_DIR}}/index.html

watch: link
    browser-sync start --files "{{OUTPUT_DIR}}/index.html" --server "{{OUTPUT_DIR}}" --port 8080