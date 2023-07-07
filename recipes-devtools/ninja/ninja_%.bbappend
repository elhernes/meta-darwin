do_compile:darwin21() {
    python3 ./configure.py --platform darwin
    ninja
}
