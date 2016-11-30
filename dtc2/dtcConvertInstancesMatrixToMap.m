%% dtcConvertInstancesMatrixToMap
% Conver instances from matrix format to map format
% 
% Input:
%   instances:          N by 3 matrix comprising [  i1start i1end   i1label;
%                                                   i2start i2end   i2label;
% Output:
%                       A Map with the keys used as label, and value
%                       comprising an N by 3 matrix (similar format to 
%                       'instances', but only with the instances of interest)
%

function instancesmap=dtcConvertInstancesMatrixToMap(instancesmatrix)

% Find all existing labels
u=unique(instancesmatrix(:,3));

%% Organize the labels by type in a containers.Map
instancesmap = containers.Map('KeyType', 'double','ValueType','any');
% Iterate all label types
for i=1:size(u,1)
    % Find all instances of that type
    instancesmap(u(i)) = instancesmatrix(find(instancesmatrix(:,3)==u(i)),:);
end



