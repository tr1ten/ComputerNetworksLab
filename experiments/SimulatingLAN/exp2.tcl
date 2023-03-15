set ns [new Simulator]
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

set udp [new Agent/UDP]
set null0 [new Agent/Null]

$ns attach-agent $sender $udp
$ns attach-agent $reciever $null0

$ns connect $udp $null0

set cbr [new Application/Traffic/CBR]

$cbr attach-agent $udp

$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"
$ns at 5.0 "finish"

$ns run


