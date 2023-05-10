set ns  [new Simulator]

$ns color 1 blue
$ns color 2 red

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf
        $ns flush-trace
        close $nf
        exec nam out.nam
        exit 0
        }

#creating ns        
for {set i 0} {$i<10} {incr i} {
set n($i) [$ns node]
}

#Creating Links
for {set i 1} {$i<10} {incr i} {
    $ns simplex-link $n([expr $i-1]) $n($i) 1Mb 10ms DropTail
}
$ns simplex-link $n(9) $n(0) 1Mb 10ms DropTail

# #TCP_Config
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0

$tcp0 set fid_ 0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink0

$ns connect $tcp0 $sink0

# #FTP Config
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns at 0.1 "$ftp0 start"
$ns at 10 "$ftp0 stop"
$ns at 10.1 "finish"

$ns run