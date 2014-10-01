records = LOAD '/user/cloudera/input.txt'; 
search_words_records = LOAD '/user/cloudera/search_words.txt'; 

TokenizedFile = foreach records generate flatten(TOKENIZE((chararray)$0)) as word; 
search_words = foreach search_words_records generate flatten(TOKENIZE((chararray)$0)) as search_words;

filtered_rec  = FILTER TokenizedFile BY (word matches '.*Dec.*' OR word matches '.*(Hackathon|hackathon).*' OR word matches '.*Chicago.*' OR word matches '.*java.*');          

fil_records = foreach filtered_rec generate ($0  matches '.*Dec.*' ? 'Dec':$0) AS rec1;                                                  
fil_records1 = foreach fil_records generate ($0 matches '.*(Hackathon|hackathon).*' ? 'hackathon':$0) AS rec2;
fil_records2 = foreach fil_records1 generate ($0 matches '.*(Chicago).*' ? 'Chicago':$0) AS rec3; 

grouped_records = GROUP fil_records2 BY rec3; 
result = foreach grouped_records generate group,COUNT(fil_records2.rec3); 

DUMP result;
