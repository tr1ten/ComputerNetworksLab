set ns  [new Simulator]

$ns color 1 blue
$ns color 2 red

$ns rtproto DV

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
for {set i 0} {$i<5} {incr i} {
set n($i) [$ns node]
}

#Creating Links
for {set i 0} {$i<4} {incr i} {
$ns duplex-link $n(4) $n($i) 512Kb 10ms DropTail
}

#Orienting The nodes
$ns duplex-link-op $n(4) $n(0) orient left-up
$ns duplex-link-op $n(4) $n(1) orient right-up
$ns duplex-link-op $n(4) $n(2) orient left-down
$ns duplex-link-op $n(4) $n(3) orient right-down

# #TCP_Config
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0

$tcp0 set class_ 1
$tcp0 set fid_ 0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink0

$ns connect $tcp0 $sink0

# #UDP_Config
set udp0 [new Agent/UDP]
$ns attach-agent $n(1) $udp0

$udp0 set class_ 1
$udp0 set fid_ 0

set null0 [new Agent/Null]
$ns attach-agent $n(2) $null0

$ns connect $udp0 $null0

# #CBR Config
set cbr0 [new Application/Traffic/CBR]
$cbr0 set rate_ 256Kb
$cbr0 attach-agent $udp0

# #FTP Config
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns at 0.1 "$ftp0 start"
$ns at 10 "$ftp0 stop"

# $ns at 0.2 "$cbr0 start"
# $ns at 10 "$cbr0 stop"
$ns at 10.1 "finish"

$ns run