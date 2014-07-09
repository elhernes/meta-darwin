do_configure_darwin (){
	uname=darwin ./configure --prefix=${prefix} --shared --libdir=${libdir}
}

do_compile_prepend_darwin () {
	export ARFLAGS=rc
}

do_install_prepend_darwin () {
	export ARFLAGS=rc
}
