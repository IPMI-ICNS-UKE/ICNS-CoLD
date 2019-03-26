function feature_matrix=select_features_CML_discrimination(features,fields)

% Function "feature_matrix=select_features_CML_discrimination(features,fields)"
% select the features from the fields "fields" to return a matrix named as
% "feature_matrix".
% "fields" is a 1*n structure, where each row is a set of features, which
% has a field named as "name" and a field named as "column".
% All the possibilities include
% "name"="features_basic", column in [1:2];
% "name"="features_sap", column in [1:4];
% "name"="features_stats", column in [1:4];
% "name"="fine_data", column in [1:4]. This option is a bit special, as
% this field contains all the nontrivial data points of every image. The
% column 5 of this field indicates the vertical position of the data point.


featuresetn=size(fields,2);
feature_matrix=[];
for i=1:1:featuresetn
    if length(fields(1,i).name)~=0
    clear matrix0 matrix
    matrix0=getfield(features,fields(1,i).name);
    matrix=matrix0(:,fields(1,i).column);
    feature_matrix=[feature_matrix matrix];
    end
end


return