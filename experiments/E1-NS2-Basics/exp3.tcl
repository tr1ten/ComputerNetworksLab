# Consider a client and server. The server is running an FTP application(over TCP).The
# client sends the request to download a file of size 10 MB from the server. Write a script to
# simulate this scenario. Let node 0 be the server and node 1 be the client. TCP packet size is
# 1500 B . Assume typical values for other parameters.

set ns [new Simulator]

$ns color 0 blue
$ns color 1 red

set tr [open "out.tr" w]
$ns trace-all $tr

set nf [open "out.nam" w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf tr
    $ns flush-trace
    close $nf
    close $tr
    exec nam out.nam &
    exit 0
}
set server [$ns node]
set client [$ns node]

$ns duplex-link $server $client 5Mb 10ms DropTail

set  tcp1 [new Agent/TCP]
set sink [new Agent/TCPSink]

$tcp1 set packetSize_ 1500

$ns attach-agent $server $tcp1
$ns attach-agent $client $sink

$ns connect $tcp1 $sink

set ftp [new Application/FTP]

$ftp attach-agent $tcp1

$ns at 0.5 "$ftp start"
$ns at 2.5 "$ftp stop"
$ns at 2.6 "finish"

$ns run




