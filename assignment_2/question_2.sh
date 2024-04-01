#!/usr/bin/bash

awk  'BEGIN{
print "Vehicle Number, SoC, Mileage(in m), Charging, Time(in min), SoH, Driver Name"
}

function replace_caps(str) {
    letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    result = ""
    for (i = 1; i <= length(str); i++) {
        char = substr(str, i, 1)
        if (char >= "A" && char <= "Z") {
            idx = index(letters, char)
            complement = length(letters) + 1 - idx
            result = result substr(letters, complement, 1)
        } else {
            result = result char
        }
    }
    return result
}

NF == 6{

# print replace_caps($0)

#	$1 = replace_caps($1)
	$6 = replace_caps($6)
#vehnum = substr($1, 7, 8)

if (substr($1, 1, 2)=="AG"){
	temp = $2
	$2 = $5
	$5 = temp
}

#fake  =""

if ($2 == 0 && $3 != 0) {
	print $1"," , $2"," , $3"," , $4"," , $5"," , $6"," , "Fake"

}
else {
print $1"," , $2"," , $3"," , $4"," , $5"," , $6 
}


}

END{

}' "$1"
