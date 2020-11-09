do_compile_darwin9() {
    python3 ./configure.py --platform darwin
    ninja
}
