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
    <li>
      <a href=\"/product/{{ product.0 }}\">{{ product.1 }} - {{ product.2 }}</a>
    </li>
  {% endfor %}
 </ul>
</body>
")

(defparameter *template-product* "
<body>
     {{ product }}

{% if debug %} debug info! {% endif %}
</body>
")


(defun products (&optional (n 5))
  (loop for i from 0 below n
        collect (list i
                      (format nil "Product nb ~a" i)
                      9.99)))

(defun get-product (n)
  ;; Query the DB.
  (list n (format nil "Product nb ~a" n) 9.99))

(defun render-products ()
  (djula:render-template*
   (djula:compile-string *template-root*)
   nil
   :products (products)))


(defun render-product (n)
  (djula:render-template*
   (djula:compile-string *template-product*)
   nil
   :product (get-product n)))

(defun render (template &rest args)
  (apply
      #'djula:render-template*
      (djula:compile-string template)
    nil
    args))

(easy-routes:defroute root ("/") ()
                      (render-products))

(easy-routes:defroute product-route ("/product/:n") (&get debug &path (n 'integer))
                      (render *template-product*
                              :product (get-product n)
                              :debug debug))

(defun start-server (&key (port *port*))
  (format t "~&Starting the web server on port ~a~&" port)
  (force-output)
  (setf *server* (make-instance 'easy-routes:easy-routes-acceptor
                   :port (or port *port*)))
  (hunchentoot:start *server*))
