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
set sender [$ns node]
set reciever [$ns node]

$ns duplex-link $sender $reciever 1Mb 10ms DropTail

set  tcp1 [new Agent/TCP]
set sink [new Agent/TCPSink]



$ns attach-agent $sender $tcp1
$ns attach-agent $reciever $sink

$ns connect $tcp1 $sink

set ftp [new Application/FTP]
set cbr [new Application/CBR]

$ftp attach-agent $tcp1
$cbr attach-agent $tcp1

$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 4.5 "$ftp stop"
$ns at 4.5 "$cbr stop"
$ns at 5.0 "finish"




