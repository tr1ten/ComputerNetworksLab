set ns [new Simulator]
set namfile [open ex_05a.nam w]
$ns namtrace-all $namfile
set tracefile [open ex_05a.tr w]
$ns trace-all $tracefile

Agent/TCP set packetSize_ 1460

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$n1 color blue
$n1 shape box
$n0 color red

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link-op $n3 $n5 orient right-down
$ns duplex-link $n4 $n6 1Mb 10ms DropTail
$ns duplex-link-op $n4 $n6 orient right
$ns duplex-link $n5 $n7 1Mb 10ms DropTail
$ns duplex-link-op $n5 $n7 orient right

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n6 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns color 1 Blue
$tcp set class_ 2

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n7 $null
$ns connect $udp $null
$udp set class_ 1

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp
$ns at 0.0 "$cbr start"
$ns at 9.0 "$cbr stop"

set filesize [expr 4*1024*1024]
$ns at 0.0 "$ftp start"
$ns at 0.0 "$ftp set type_ FTP"
$ns at 0.0 "$ftp set data_ $filesize"
$ns at 10.0 "$ftp stop"

proc finish {} {
    global ns namfile tracefile
    $ns flush-trace
    close $namfile
    close $tracefile
    exec nam ex_05a.nam &
    exec xgraph -bb -tk -x Time -y Bytes ex05a.data -bg white &
    exec xgraph -bb -tk -x Time -y Packets ex05a_packets.data -bg white &
    exit 0
}
$ns at 100.0 "finish"
$ns run
