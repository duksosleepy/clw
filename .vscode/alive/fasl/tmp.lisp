(uiop:define-package clw
  (:use #:cl
        #:hunchentoot)
  (:export :start-server))
(in-package #:clw)

(djula:add-template-directory (asdf:system-relative-pathname "clw" "templates/"))

(defparameter +base.html+ (djula:compile-template* "base.html"))

(defparameter +products.html+ (djula:compile-template* "products.html"))

(defparameter +product.html+ (djula:compile-template* "product.html"))

(defparameter *port* 4444 "The application port.")

(defun products (&optional (n 5))
       (loop for i from 0 below n
             collect (get-product i)))


(defun get-product (n)
       ;; Query the DB.
       (list :id n :name (format nil "Product nb ~r" n) :price 9.99))

(defun search-products (products query)
       (loop for product in products
               if (search query (second product) :test #'equalp)
             collect product))

; (defun render-products ()
;        (djula:render-template*
;         (djula:compile-string *template-root*)
;         nil
;         :products (products)))

; (defun render-product (n)
;        (djula:render-template*
;         (djula:compile-string *template-product*)
;         nil
;         :product (get-product n)))

; (defun render (template &rest args)
;        (apply
;         #'djula:render-template*
;         (djula:compile-string template)
;         nil
;         args))

; (def-filter :myfilter-name (var arg)
;             (body))

; (def-filter :add (it n)
;             (+ it (parse-integer n)))

(easy-routes:defroute root ("/" :method :get) ()
                      (djula:render-template* +products.html+
                                              nil
                                              :products (products)))

(easy-routes:defroute hello-route ("/hello" :method :get) () "hello new route")

(easy-routes:defroute product-route ("/product/:n" :method :get) (&path (n 'integer))
                      (djula:render-template* +product.html+
                                              nil
                                              :product (get-product n)))

(easy-routes:defroute name ("/tasks/:id" :method :get) (debug &get z)
                      (format nil "we want the task of id: ~a with parameters debug: ~a and z: ~a" id debug z))

(defun serve-static-assets ()
       "Then reference static assets with the /static/ URL prefix."
       (push (hunchentoot:create-folder-dispatcher-and-handler
              "/static/"
              (asdf:system-relative-pathname :clw "src/static/"))
             ;;                                        ^^^ starts without a /
             hunchentoot:*dispatch-table*))

(defun start-server (&key (port *port*))
       (format t "~&Starting the web server on port ~a~&" port)
       (force-output)
       (setf *server* (make-instance 'easy-routes:easy-routes-acceptor
                                     :port (or *port* 4444)
                                     :document-root #p"www/"))
       (serve-static-assets)
       (hunchentoot:start *server*))

(defun main ()
       (start-server :port (find-port:find-port :min *port*))
       (sleep most-positive-fixnum))
