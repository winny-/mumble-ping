#lang info
(define collection "mumble-ping")
(define version "1.1.3")
(define deps '("base" "rackunit-lib" "typed-racket-lib" "rackunit-typed" "bitsyntax"))
(define build-deps '("scribble-lib" "racket-doc" "typed-racket-doc"))
(define scribblings '(("scribblings/mumble-ping.scrbl" () (net-library))))
(define pkg-info "Ping mumble servers")
