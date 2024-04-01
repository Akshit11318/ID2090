#!/usr/bin/bash

if [ $# -ne 2 ]; then
    echo "Please provide the input / test cases file"
    exit 1
fi

is_num() {
    local input=$1
    if [[ $input =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

declare -a num
declare -a test
count=0
count2=0

while IFS=', ' read -ra numbers; do
    for number in "${numbers[@]}"; do
        num+=("$number")
        ((count++))
    done
done < "$1"

while IFS= read -r testcase; do
    if [ -z "$testcase" ]; then
    	test+=("$testcase")
        ((count2++))
        continue
    fi
    if ! is_num "$testcase"; then
        test+=("$testcase is not an integer, please provide integer inputs")
        ((count2++))
        continue
    fi
    test+=("$testcase")
    ((count2++))
done < "$2"

if [ $count -ne 5 ]; then
    echo "Error: There should be exactly 5 numbers in the input file"
    exit 1
fi

a=${num[0]}
b=${num[1]}
c=${num[2]}
f1=${num[3]}
f2=${num[4]}

fibo() {
    local n=$1
    local a=$2
    local b=$3
    local c=$4
    local f1=$5
    local f2=$6
    local i
    local result

    if [ $n -eq 1 ]; then
        echo $f1
        return
    fi
    if [ $n -eq 2 ]; then
        echo $f2
        return
    fi

    for ((i = 3; i <= n; i++)); do
        result=$(( (b * f1 + c * f2) / a ))
        f1=$f2
        f2=$result
    done
    echo $result
}

for ((i = 1; i <= ${test[0]}; i++)); do
    if [ -z "${test[$i]}" ]; then
    	echo " "
        continue
    fi
    if ! is_num "${test[$i]}"; then
    echo "${test[$i]}"
    continue
    fi
    result=$(fibo ${test[$i]} $a $b $c $f1 $f2)
    echo "$result"
done









