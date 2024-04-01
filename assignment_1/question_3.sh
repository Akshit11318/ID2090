#!/usr/bin/bash
#link="https://id2090assignment1.s3.ap-south-1.amazonaws.com/Q3.txt"
wget -q $1 
# AWK script
tail -n +53 Q3.txt | awk 'BEGIN {
        FS = " "
        ORS = ""
}
#this function has been gussed as quadratic and then confirmed to be 72x + 2x2
#which we got from plotting the data points in sagemath and fitting a function
function inverse(value) {
  result = sqrt(0.5 * (value + 648)) - 18
  return result
}
#/[[:lower:]]{2}23b[[:digit:]]{3}/{
#        print "\n"
#}
{       print $1 ","
        for(i = 2; i <= NF; i++) {
            printf("%c", inverse($i))
        }
}' >OUTPUT.txt

rm Q3.txt
echo "OUTPUT.txt generated sucessfully"
