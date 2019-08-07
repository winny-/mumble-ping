#lang info
(define collection "mumble-ping")
(define version "1.1.2")
(define deps '("base" "typed-racket-lib" "rackunit-typed" "bitsyntax"))
(define build-deps '("scribble-lib" "racket-doc" "typed-racket-doc"))
(define scribblings '(("scribblings/mumble-ping.scrbl" () (net-library))))
(define pkg-info "Ping mumble servers")
