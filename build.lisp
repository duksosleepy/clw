(load "clw.asd")

(ql:quickload "clw")

(sb-ext:save-lisp-and-die "clw" :executable t :toplevel #'clw::main)
