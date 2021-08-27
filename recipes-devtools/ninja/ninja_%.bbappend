do_compile:darwin19() {
    python3 ./configure.py --platform darwin
    ninja
}
