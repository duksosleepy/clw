(uiop:define-package clw
  (:use #:cl))
(in-package #:clw)

(defvar *server* nil
        "Server instance (Hunchentoot acceptor).")

(defparameter *port* 8899 "The application port.")

(easy-routes:defroute root ("/") ()
                      "hello app")

(defun start-server (&key (port *port*))
  (format t "~&Starting the web server on port ~a~&" port)
  (force-output)
  (setf *server* (make-instance 'easy-routes:easy-routes-acceptor
                   :port port))
  (hunchentoot:start *server*))
