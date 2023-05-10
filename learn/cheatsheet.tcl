# This is a comment
set variable_name value        # Assign value to variable_name
puts "Hello, world!"          # Output string to console

## Control statements
if {$x > 5} {
    puts "x is greater than 5"
} elseif {$x == 5} {
    puts "x is equal to 5"
} else {
    puts "x is less than 5"
}

while {$x < 10} {
    puts $x
    incr x
}

for {set i 0} {$i < 10} {incr i} {
    puts $i
}

foreach element $list {
    puts $element
}

## List

set my_list {apple banana cherry}
puts [lindex $my_list 1]   # Output: banana
puts [llength $my_list]    # Output: 3
set my_list [linsert $my_list 1 "orange"]
puts $my_list              # Output: apple orange banana cherry


## Strings
set my_string "Hello, world!"
puts [string length $my_string]   # Output: 13
puts [string index $my_string 0]  # Output: H
puts [string replace $my_string 0 4 "Goodbye"]  # Output: Goodbye, world!


## Functions

proc my_function {arg1 arg2} {
    # Do something with arg1 and arg2
    return $result
}

set result [my_function $arg1 $arg2]