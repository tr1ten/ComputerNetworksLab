set ns [new Simulator]
set namfile [open lab4.nam w]
$ns namtrace-all $namfile
set tracefile [open lab4.tr w]
$ns trace-all $tracefile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
$n1  color red
$n1 shape square

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link-op $n0 $n1 orient right-down

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link-op $n0 $n2 orient right

$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link-op $n1 $n2 orient right-up

$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link-op $n2 $n3 orient right

set lan [$ns newLan "$n3 $n4 $n5 $n6" 10Mb 10ms LL Queue/DropTail Mac/802_3 Channel]

set errmodel [new ErrorModel]
$errmodel set rate_ 0.2
$errmodel ranvar [new RandomVariable/Uniform]
$errmodel drop-target [new Agent/Null]
$ns lossmodel $errmodel $n2 $n3

set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
set filesize [expr 4*1024*1024]
$ns at 0.0 "$ftp send $filesize"

proc finish {} {
    global ns namfile tracefile
    $ns flush-trace
    close $namfile
    close $tracefile

    set awkCode {
        BEGIN{}
        {
            if($1 == "r" && $4 == 5 && $6 > 1000)
            {
                count_bytes = count_bytes + $6 - ($6 % 1000);
                print $2,count_bytes >> "lab4.data";
            }
            else
            if($1 == "d" && $5 == "tcp" && $6 > 1000)
            {
                count_packets++; print $2,count_packets >> "lab4_packets.data";
            }
        }
        END{}
    }
    exec awk $awkCode lab4.tr
    exec nam lab4.nam &
    exec xgraph -bb -tk -x Time -x Bytes lab4.data -bg white &
    exec xgraph -bb -tk -x Time -y packets lab4_packets.data -bg white &

    exit 0

}
$ns at 100.0 "finish"
$ns run