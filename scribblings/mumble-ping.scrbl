#lang scribble/manual

@(require (for-label typed/racket/base mumble-ping))

@title{Mumble Ping}

@hyperlink["https://unmaintained.tech/"]{@image{unmaintained.svg}}

@section{Pinging Mumble Servers}

This library provides a simple interface to query Mumble servers.
It is implemented in Typed Racket.

@defmodule[mumble-ping]

@defproc[(mumble-ping [host String] [port Integer 64738]) (Option mumble-ping-response)]{
Query Mumble server at @racketid[host] on @racketid[port].
This procedure uses the UDP Ping technique described at the @hyperlink["https://wiki.mumble.info/wiki/Protocol"]{Mumble Wiki}.
}

@defstruct[mumble-ping-response
    ([version Mumble-Version]
     [users Exact-Nonnegative-Integer]
     [max-users Exact-Nonnegative-Integer]
     [max-bandwidth Exact-Nonnegative-Integer]
     [latency Exact-Nonnegative-Integer])
    #:transparent]{
A response from a mumble server. The fields are:
@itemlist[@item{@racketid[version] is the Mumble server version.}
          @item{@racketid[users] is the current number of connected users.}
          @item{@racketid[max-users] is the maximum number of users the server supports.}
          @item{@racketid[max-bandwidth] is the maximum bandwidth of the server.}
          @item{@racketid[latency] is the duration between request and response in milliseconds.}]}

@defidform[Mumble-Version]{Alias for @racket[(Immutable-Vector Byte Byte Byte Byte)].}

@section{Project Information}

@itemlist[
 @item{MIT/X Licensed}
 @item{@hyperlink["https://github.com/winny-/mumble-ping"]{Source code on GitHub}}
]

@subsection{Racket Compatibility}

@itemlist[
@item{7.1}
@item{7.2}
@item{7.3}
@item{7.4}
@item{And likely any later version.}
]

@racket[Immutable-Vector] is apparently not provided by
@racketmodname[typed/racket] or @racketmodname[typed/racket/base] in 7.0 or
earlier.

@section{To Do}

Implement a protobuf client that connects to the Mumble server, gets the user list, and disconnects.