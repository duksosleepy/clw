# Clw
Web application built in [Common Lisp](https://lisp-lang.org/)

# Installation
### With SBCL (ASDF) (recommended)
1. Load .asd
    ```bash
    (load "clw.asd")
    ```
2. Load into system
    ```bash
    (asdf:load-system "clw")
    ```
3. Check if the package exists
    ```bash
    (find-package :clw)
    ```

# Usage
1.
    ```shell
    (clw::start-server)
    ```

    or
2.
    ```shell
    sbcl --load run.lisp
    ```

Starting the web server on [localhost:random-port](http://localhost:random-port)

# Build executable

1.
    ```shell
    (sb-ext:save-lisp-and-die "clw" :executable t :toplevel #'clw::main)
    ```
    or
2.
    ```shell
    (uiop:dump-image "clw.image" :executable t)
    ```

    or
3.
    ```shell
    sbcl --load build.lisp
    ```
