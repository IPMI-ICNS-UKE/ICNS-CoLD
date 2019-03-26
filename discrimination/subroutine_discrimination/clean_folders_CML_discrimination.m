 function cclean=clean_folders_CML_discrimination(foldername)
 
% Function "clean_folders_CML_discrimination(folder)"
% is used to delete all the ".txt", ".csv" and ".dat" files in the folder 
% with the name "foldername".

%% load position
delete('*.txt');
delete('*.csv');
delete('*.dat');
 return;
