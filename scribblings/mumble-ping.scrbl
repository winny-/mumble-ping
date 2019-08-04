#lang scribble/manual

@(require (for-label typed/racket/base mumble-ping))

@title{Mumble Ping}

@section{Pinging Mumble Servers}

This library provides a simple interface to query Mumble servers.
It is implemented in Typed Racket.

@defmodule[mumble-ping]

@defproc[(mumble-ping [host String] [port Integer 64738]) (U mumble-ping-response False)]{
Query Mumble server at @racketid[host] on @racketid[port].
This procedure uses the UDP Ping technique described at the @hyperlink["https://wiki.mumble.info/wiki/Protocol"]{Mumble Wiki}.
}

@defstruct[mumble-ping-response
    ([version (Immutable-Vector Byte Byte Byte)]
     [users Integer]
     [max-users Integer]
     [max-bandwidth Integer])
    #:transparent]{
A response from a mumble server. The fields are:
@itemlist[@item{@racketid[version] is the Mumble server version.}
          @item{@racketid[users] is the current number of connected users.}
          @item{@racketid[max-users] is the maximum number of users the server supports.}
          @item{@racketid[max-bandwidth] is the maximum bandwidth of the server.}]}

@section{Project Information}

@itemlist[
 @item{MIT/X Licensed}
 @item{@hyperlink["https://github.com/winny-/mumble-ping"]{Source code on GitHub}}
]


@section{To Do}

Implement a protobuf client that connects to the Mumble server, gets the user list, and disconnects.