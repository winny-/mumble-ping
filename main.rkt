#lang typed/racket/base

#|
From https://wiki.mumble.info/wiki/Protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

UDP Ping packet
Mumble supports querying the following data by sending a ping packet to the target server. Both the request and the response packets are formatted in Big Endian.

The ping request packet contains the following data:

Width	Data type	Value	Comment
4 bytes	int	0	Denotes the request type
8 bytes	long long	ident	Used to identify the reponse.

The response will then contain the following data:

Width	Data type	Value	Comment
4 bytes	int	Version	e.g., \x0\x1\x2\x3 for 1.2.3. Can be interpreted as one single int or four signed chars.
8 bytes	long long	ident	the ident value sent with the request
4 bytes	int	Currently connected users count
4 bytes	int	Maximum users (slot count)
4 bytes	int	Allowed bandwidth
|#

(provide mumble-ping
         (struct-out mumble-ping-response)
         Mumble-Version)

(require bitsyntax
         racket/function
         racket/math
         racket/udp)

(define-type Mumble-Version (Immutable-Vector Byte Byte Byte Byte))

(struct mumble-ping-response ([version : Mumble-Version]
                              [users : Exact-Nonnegative-Integer]
                              [max-users : Exact-Nonnegative-Integer]
                              [allowed-bandwidth : Exact-Nonnegative-Integer]
                              [latency : Exact-Nonnegative-Integer])
  #:transparent)

(: mumble-ping ((String) (Integer) . ->* . (Option mumble-ping-response)))
(define (mumble-ping host [port 64738])
  (define socket (udp-open-socket))
  (udp-connect! socket host port)

  (define ident  (exact-round (current-inexact-milliseconds)))
  (define request-packet (bit-string->bytes
                          (bit-string (0 :: bytes 4)
                                      (ident :: big-endian bytes 8))) )
  (udp-send socket request-packet)
  (define response-bytes (make-bytes 24))
  (udp-receive! socket response-bytes)
  (define latency (cast (- (exact-round (current-inexact-milliseconds)) ident)
                        Exact-Nonnegative-Integer))
  (udp-close socket)

  (define resp (parse-response-packet response-bytes))
  (and resp (struct-copy mumble-ping-response resp [latency latency])))


(: parse-response-packet (Bytes . -> . (Option mumble-ping-response)))
(define (parse-response-packet pkt)
  (bit-string-case pkt
                   #:on-short (const #f)
                   ([(v0 :: signed integer bytes 1)
                     (v1 :: signed integer bytes 1)
                     (v2 :: signed integer bytes 1)
                     (v3 :: signed integer bytes 1)
                     (:: big-endian bytes 8)
                     (users :: big-endian signed integer bytes 4)
                     (max-users :: big-endian signed integer bytes 4)
                     (allowed-bandwidth :: big-endian signed integer bytes 4)]
                    (mumble-ping-response (cast (vector->immutable-vector (vector v0 v1 v2 v3))
                                                Mumble-Version)
                                          (cast users Exact-Nonnegative-Integer)
                                          (cast max-users Exact-Nonnegative-Integer)
                                          (cast allowed-bandwidth Exact-Nonnegative-Integer)
                                          0))))


(module+ test
  (require typed/rackunit)
  (define t1-bytes #"\0\1\2\4\0\0\1l[y\366E\0\0\0\3\0\0\0E\0\1\373\320")
  (define t1-response (mumble-ping-response #(0 1 2 4) 3 69 130000 0))
  (check-equal? t1-response (parse-response-packet t1-bytes)))
