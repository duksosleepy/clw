(defpackage clw/tests/main
  (:use :cl
        :clw
        :rove))
(in-package :clw/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :clw)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
