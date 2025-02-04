(defsystem "clw"
  :version "0.0.1"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "clw/tests"))))

(defsystem "clw/tests"
  :author ""
  :license ""
  :depends-on ("clw"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for clw"
  :perform (test-op (op c) (symbol-call :rove :run c)))
