(ASDF:defsystem "clw"
  :version "0.0.1"
  :author ""
  :license ""
  :depends-on (:hunchentoot
               :easy-routes
               :djula)
  :components ((:module "src"
                        :components
                        ((:file "main"))))
  :description "CLW"
  :in-order-to ((asdf:test-op (asdf:test-op "clw/tests"))))

(ASDF:defsystem "clw/tests"
  :author ""
  :license ""
  :depends-on ("clw"
               "rove")
  :components ((:module "tests"
                        :components
                        ((:file "main"))))
  :description "Test system for clw"
  :perform (asdf:test-op (op c) (funcall (find-symbol "RUN" :rove) c)))
