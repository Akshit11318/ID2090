#!/bin/bash

curl -s "https://apod.nasa.gov/apod/archivepixFull.html" | \
sed "s/<a .*\">//g" | \
sed "s/<\/a><br>//g" | \
head -n -27 | \
tail -n +47 > output.txt

awk 'BEGIN {
    FS = ":"
}

# Main processing block
$1 ~ /^[0-9]{4} [A-Z][a-z]+ [0-9]{1,2}$/ || $1 ~ /^[A-Z][a-z]+ [0-9]{1,2} [0-9]{4}$/ {
    year_pattern = "^[0-9]{4}$";
    day_pattern = "^[0-9]{1,2}$";

    split($1, date, " ");
    month_names = "January February March April May June July August September October November December";
    split(month_names, months, " ");
    for (i = 1; i <= 12; i++) {
        month_mapping[months[i]] = i;
    }

    # Get the numerical value of the month
    if (match(date[1], year_pattern)) {
        if (match(date[2], day_pattern)) {
            year = date[1];
            day = date[2];
            month = date[3];
        } else {
            year = date[1];
            day = date[3];
            month = date[2];
        }
    } else if (match(date[1], day_pattern)) {
        if (match(date[2], year_pattern)) {
            year = date[2];
            day = date[1];
            month = date[3];
        } else {
            year = date[3];
            day = date[1];
            month = date[2];
        }
    } else {
        if (match(date[2], year_pattern)) {
            year = date[2];
            day = date[3];
            month = date[1];
        } else {
            year = date[3];
            day = date[2];
            month = date[1];
        }
    }
    
    monum = month_mapping[month];

    # remin = $2 FS ($3 FS ... FS $NF)
    remin = $2;
    for (i = 3; i <= NF; i++) {
        remin = remin FS $i;
    }

    if (year % day == 0) {
        answer1[++count1] = remin;
    }
    if (year % monum == 0) {
        answer2[++count2] = remin;
    }
}

END {
    for (i = 1; i <= count1; i++) {
        print answer1[i] > "answer_1a.csv";
    }
    for (i = 1; i <= count2; i++) {
        print answer2[i] > "answer_1b.csv";
    }
}' output.txt

