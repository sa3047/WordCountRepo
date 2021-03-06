//1. Read the input file from HDFS
records = LOAD '/user/cloudera/input.txt'; 

//2.Tokenize the file by line
TokenizedFile = foreach records generate flatten(TOKENIZE((chararray)$0)) as word; 


filtered_rec  = FILTER TokenizedFile BY (word matches '.*Dec.*' OR word matches '.*(Hackathon|hackathon).*' OR word matches '.*Chicago.*' OR word matches '.*java.*');          
//3. Filter the recrods by specified word
fil_records = foreach filtered_rec generate ($0  matches '.*Dec.*' ? 'Dec':$0) AS rec1;                                                  
fil_records1 = foreach fil_records generate ($0 matches '.*(Hackathon|hackathon).*' ? 'hackathon':$0) AS rec2;
fil_records2 = foreach fil_records1 generate ($0 matches '.*(Chicago).*' ? 'Chicago':$0) AS rec3; 

grouped_records = GROUP fil_records2 BY rec3; 
result = foreach grouped_records generate group,COUNT(fil_records2.rec3); 

DUMP result;
