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
    ```bash
    (clw::start-server)
    ```

Starting the web server on [localhost:8899](http://localhost:8899)
