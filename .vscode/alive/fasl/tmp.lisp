(uiop:define-package clw
  (:use #:cl)
  (:export :start-server))
(in-package #:clw)

(defvar *server* nil
        "Server instance (Hunchentoot acceptor).")

(defparameter *port* 8899 "The application port.")

(defparameter *template-root* "
<title> Lisp web app </title>
<body>
  <ul>
  {% for product in products %}
    <li> {{ product.1 }} - {{ product.2 }} </li>
  {% endfor %}
 </ul>
</body>
")

(defun products (&optional (n 5))
  (loop for i from 0 below n
        collect (list i
                      (format nil "Product nb ~a" i)
                      9.99)))

(defun render-products ()
  (djula:render-template*
   (djula:compile-string *template-root*)
   nil
   :products (products)))

(easy-routes:defroute root ("/") ()
                      (render-products))

(defun start-server (&key (port *port*))
  (format t "~&Starting the web server on port ~a~&" port)
  (force-output)
  (setf *server* (make-instance 'easy-routes:easy-routes-acceptor
                   :port (or port *port*)))
  (hunchentoot:start *server*))
