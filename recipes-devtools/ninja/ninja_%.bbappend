do_compile_darwin19() {
    python3 ./configure.py --platform darwin
    ninja
}
