#!/usr/bin/bash

awk -v inputwo="$2" 'BEGIN{

}
NR>1{
 num_words = NF - 1;
    gsub(/[,.]/, "", $0);
    for (i = 2; i <= NF; i++) {
        word = $i;
        words[$1][word]++;
                if (!(word in unique_words)) {
            unique_words[word] = 1;
        }
    }
    total_words[$1] = num_words;

}
function log2(x) {
    return log(x) / log(2);
}
END{
#we have total words in each line and hits of the word

totdoc=length(total_words);
#tf-idf calculation
  
for (doc in words){
        for (word in words[doc]) {
        tf[word] += (words[doc][word] / (total_words[doc] * 1.0));
        }
}

for (doc in words){
        for (word in words[doc]) {
        yesdoc[word]++;
}
}

 for (word in yesdoc) {
        idf[word] = log2((totdoc + 1.0) / (yesdoc[word] + 1.0));
    }

for (word in unique_words) {       
#printf("%s idf %0.4f yesdoc %d tfword %0.4f\n ",word,idf[word],yesdoc[word],tf[word]);
}


for (word in unique_words) {
tfidf = (1.0/totdoc)*tf[word]*idf[word]
answers[word]=tfidf
}
for(word in unique_words){
	#print word ," == ", answers[word]
}    
 
 #sort
 PROCINFO["sorted_in"] = "@val_num_desc";



if(inputwo!=""){
printf("%0.4f\n",answers[inputwo]);
}else{
count = 0;
    for (word in answers) {
        if (count < 5) {
            printf("%s, %0.4f\n",word,answers[word]);
            count++;
        } else {
            break;
        }
    }
}

}' <"$1"

