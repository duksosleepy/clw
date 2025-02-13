(uiop:define-package clw
  (:use #:cl)
  (:export :start-server))
(in-package #:clw)

(defvar *server* nil
        "Server instance (Hunchentoot acceptor).")

(defparameter *port* 8899 "The application port.")

(defparameter *template-root* "

<form action=\"/\" method=\"GET\">
  <div>
    <label for=\"query\">What do you search for?</label>
    <input name=\"query\" id=\"query\" placeholder=\"Search…\" />
  </div>
  <div>
    <button>Search</button>
  </div>
</form>

{% if query %}
<div> query is: {{ query }} </div>

<ul>
  {% for product in results %}
    <li>
      <a href=\"/product/{{ product.0 }}\">{{ product.1 }} - {{ product.2 }}</a>
    </li>
  {% endfor %}
</ul>
{% endif %}
")

(defparameter *template-product* "
<body>
     {{ product }}

{% if debug %} debug info! {% endif %}
</body>
")


(defun products (&optional (n 5))
  (loop for i from 0 below n
        collect (get-product i)))

(defun get-product (n)
  ;; Query the DB.
  (list n (format nil "Product nb ~r" n) 9.99))

(defun search-products (products query)
  (loop for product in products
          if (search query (second product) :test #'equalp)
        collect product))

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

(easy-routes:defroute root ("/") (query)
                      (render *template-root*
                              :results (search-products (products) query)
                              :query query))

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
