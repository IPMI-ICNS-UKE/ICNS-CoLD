function predicted=supervised_learning_CML_discrimination(matrix_tr,testing_instance_matrix,n_learn,p_out);

% Function "predicted=supervised_learning_CML_discrimination(matrix_tr,testing_instance_matrix,n_learn,p_out)"
% performs supervised machine learning by using the trainig matrix
% "matrix_tr" on the testing matrix "testing_instance_matrix", by using libsvm.
% We used the toolbox "libsvm" developed by
% "Chang, C.-C. & Lin, C.-J. LIBSVM: a library for support vector machines. 
% ACM transactions on intelligent systems and technology (TIST) 2, 27 (2011)",
% which is available at https://www.csie.ntu.edu.tw/~cjlin/libsvm/.
% In total it performs "n_learn" trials of learning. For each trial, random "p_out"
% of  the data points in training set are left off. The output "predicted" is a matrix
% with the number of rows which is the same as the data point in testing set and "n_learn"
% columns. 


size_max = max(size(matrix_tr,2));
matrix_features = matrix_tr(:,(1:size_max-1));
vector_labels =  matrix_tr(:,size_max);

for k = 1:size_max-1
max_scale(k) = max(matrix_features(:,k));  
matrix_features(:,k) = matrix_features(:,k)./max_scale(k);
end

% figure
% imagesc(matrix_features)
% colorbar

% compute the leave one out cross correlation
p=size(matrix_tr,1);
tr=fix(p*(1-p_out));
combos = zeros(n_learn,tr);
for i_learn=1:1:n_learn
    combos(i_learn,:)=randperm(p,tr);
end

% count = 0;
% maxerror = 0; 

% for in = 1:p %in esima iterazione corrisponde alla riga p-in+1 lasciata fuori
%     
%     training_label_vector=vector_labels(combos(in,:));
%     training_instance_matrix=matrix_features(combos(in,:),:);
%     
%     testing_label_vector=zeros(p-tr);
%     testing_instance_matrix=matrix_features(p-in+1,:);
%      
%     model = svmtrain(training_label_vector, training_instance_matrix,'-s 0 -t 0 -c 1');% -v 350');%default '-t 2 -g 1 -c 1'
%     [predicted_label, accuracy_svm, decision_values] = svmpredict(testing_label_vector, testing_instance_matrix, model);
%     
%     e_bis(in)=predicted_label-vector_labels(p-in+1); %predicted-real
%     
%     if abs(e_bis(in)) == maxerror
%         count = count +1;
%     else count = count;
%     end
% end
% rmse_totale = sqrt((sum(e_bis.^2))/p);
% accuracy = (count/p)*100;
% 
% 
% count_chance = 0;
% num_chance = 1000;
% e_bis_chance_mat = zeros(p,num_chance);
% e_bis_chance = zeros(p,1);
% 
% for meli = 1: num_chance
%     vector_labels_nuovo = vector_labels(randperm(p));
%     
%     % first way
%     e_bis_chance_mat(:,meli) = vector_labels-vector_labels_nuovo;
%     
%     %second way
%     for kk =1:p
%         e_bis_chance(kk) = vector_labels(kk)-vector_labels_nuovo(kk);
%         if abs(e_bis_chance(kk)) <= maxerror
%             count_chance = count_chance +1;
%         else count_chance = count_chance;
%         end   
%     end  
%     accuracy_chance(meli) = (count_chance/p)*100;
%     count_chance = 0;
% end
% 
% accuracy_big = mean(accuracy_chance);
% accuracy_big_mat = ((sum(e_bis_chance_mat(:)==0))/(p*num_chance))*100;



%% testing 


% testing_instance_matrix=load(matr_testing);
% imagesc(testing_instance_matrix);
% colorbar


size_testing = max(size(testing_instance_matrix,1));
testing_label_vector = zeros(size_testing,1);

for k = 1:size_max-1
testing_instance_matrix(:,k) = testing_instance_matrix(:,k)./max_scale(k);
end

size_testing = max(size(testing_instance_matrix,1));
testing_label_vector = zeros(size_testing,1);
predicted=zeros(size_testing,n_learn);
for in = 1:1:n_learn %in esima iterazione corrisponde alla riga p-in+1 lasciata fuori
    
    training_label_vector=vector_labels(combos(in,:));
    training_instance_matrix=matrix_features(combos(in,:),:);
     
    model = svmtrain(training_label_vector, training_instance_matrix,'-s 0 -t 0 -c 1');% -v 350');%default '-t 2 -g 1 -c 1'
    [predicted_label, accuracy_svm, decision_values] = svmpredict(testing_label_vector, testing_instance_matrix, model);
    
    predicted(:,in)=predicted_label;
end

% figure
% imagesc(predicted)
% title('predicted labels')
% colorbar
% colormap(jet)

% size_predicted=size(predicted);
% predicted_index=nan(size_predicted(1),1);
% warning off
% for ipr=1:1:size_predicted(1)
% [predicted_m,stats]=robustfit(zeros(1,size_predicted(2)),predicted(ipr,:));
% predicted_index(ipr)=fix(predicted_m(1)+0.5);
% end
% warning on
% figure
% imagesc(predicted_index)
% title('predicted index')
% colorbar
% colormap(jet)

% save pred.mat predicted;
end