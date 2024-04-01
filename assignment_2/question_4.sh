#!/usr/bin/bash
declare -a unique_roll

unique_roll_data=$(awk -v file2="$3" '$2 != "Roll" {
    gsub(/,/, "", $0)
    if (!seen[$2]) {
        unique_roll[$2] = 1
        seen[$2] = 1
    }
}
END {
    while ((getline < file2) > 0) {
        gsub(/,/, "", $0)
        if ($1 != "Roll" && !seen[$1]) {
            unique_roll[$1] = 1
            seen[$1] = 1
        }
    }
    close(file2)
for (roll_number in unique_roll) {
     print roll_number
}
}' "$2")
while IFS= read -r rollno; do
    unique_roll+=("$rollno")
done <<< "$unique_roll_data"
#call awk to compare inside a for loop 
for rollno in "${unique_roll[@]}"; do
        rollcall1a=$(awk -v roll="$rollno" '$2 == roll {print $1}' "$2")
        #rollcall1b=$(awk -v roll="$rollno" '$2 == roll {print $2}' "$2")
        #rollcall2a=$(awk -v roll="$rollno" '$1 == roll {print $1}' "$3")
        rollcall2b=$(awk -v roll="$rollno" '$1 == roll"," {print $2}' "$3")
    if [[ "$rollcall1a" == "" ]]; then
        rollcall1a="NULL,"
    fi
    if [[ "$rollcall2b" == "" ]]; then
        rollcall2b="NULL"
    fi
echo "$rollcall1a" "$rollno""," "$rollcall2b" >>fulljoin.csv
done

awk -v inp="$1" '
BEGIN {
  printf("ID, Roll, Name\n")
}

inp == "-F" {
  print $0
}

inp == "-I" {
  if($1 != "NULL," && $3 != "NULL"){
    print $0
  }
}

inp == "-L" {
  if($1 != "NULL,"){
    print $0
  }
}

inp == "-R" {
  if($3 != "NULL"){
    print $0
  }
}
' < fulljoin.csv

rm fulljoin.csv
