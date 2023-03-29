set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam
    exit 0
}
#creating Nodes        
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set lan [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5 $n6" 100Mb 0.5ms LL Queue/DropTail Mac/802_3 Channel Phy/WiredPhy]

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n6 $null

$ns connect $udp $null

set cbr [new Application/Traffic/CBR];
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp

$ns at 0.0 "$cbr start"
$ns at 24.5 "$cbr stop"

$ns at 25 "finish" 
$ns run