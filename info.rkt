#lang info
(define collection "mumble-ping")
(define version "1.0.1")
(define deps '("base" "typed-racket-lib" "rackunit-typed" "bitsyntax"))
(define build-deps '("scribble-lib" "racket-doc" "typed-racket-doc"))
(define scribblings '(("manual.scrbl" () (net-library))))
