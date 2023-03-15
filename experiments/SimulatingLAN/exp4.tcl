set ns  [new Simulator]

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
for {set i 0} {$i<4} {incr i} {
set n($i) [$ns node]
}

$ns duplex-link $n(1) $n(2) 0.3Mb 100ms DropTail

$ns duplex-link $n(0) $n(2) 0.5Mb 40ms DropTail ;# simplex
$ns duplex-link $n(2) $n(3) 2Mb 10ms DropTail

#Set Queue Size of link (n(2)-n3) to 40
$ns queue-limit $n(2) $n(3) 40

set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n(0) $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n(2) $sink
$ns connect $tcp $sink
$tcp set window_ 8000
$tcp set fid_ 1
$tcp set packetSize_ 512

#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n(1) $udp
set null [new Agent/Null]
$ns attach-agent $n(3) $null
$ns connect $udp $null
$udp set fid_ 2

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
#Setup a FTP over 

$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 10.0 "$ftp stop"
$ns at 10.5 "$cbr stop"

$ns at 11.0 "finish"
$ns run