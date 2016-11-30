%% dtcFindInstancesFromLabelStream
% Finds all instances in a label stream and return the start/end of that 
% instance and and the class label.
%
% Three different output formats are provided.
% 
% Input:
%   labelstream:        row or column vector containing the label of each 
%                       sequential sample of the data stream
% Output:
%   instances:          N by 3 matrix comprising [  i1start i1end   i1label;
%                                                   i2start i2end   i2label;
%                                                   ...     ...     ...
%                                                   iNstart iNend   iNlabel;]
%                       The instances are ordered as the are discovered in the 
%                       label stream
%
%   instancesgrouped:   A Map with the keys used as label, and value
%                       comprising an N by 3 matrix (similar format to 
%                       'instances', but only with the instances of interest)
%
%   instancesgroupedc:  A cell array of structs comprising instances grouped by label
%                       instancesgroupedc{n}.label:     label 
%                       instancesgroupedc{n}.range:     N by 3 matrix with
%                       the range of the instances (similar format to 
%                       'instances', but only comprising the instances of interest)
%


function [instances instancesgrouped instancesgroupedc]=dtcFindInstancesFromLabelStream(labelstream)

%% Make sure we have a row vector as input
if iscolumn(labelstream)
    labelstream=labelstream';
end

%% Find the range and type of all instances
% instrange is a nx2 matrix with the start/end time of each instance.
instances = dtcFindTimeSeriesDiscontinuities(labelstream,0);

% Add a column to instrange to store the labels of each instance 
instances = [instances zeros(size(instances,1),1)];

% Iterate all instances to find their type, store it in instrange
for i=1:size(instances,1)
    instances(i,3) = labelstream(instances(i,1));
end

%% Organize the labels by type in a cell of structure
% Find all existing labels
u=unique(instances(:,3));

% Iterate all label types
for i=1:size(u,1)
    % Find all instances of that type
    instancesgroupedc{i}.label = u(i);
    instancesgroupedc{i}.range = instances(find(instances(:,3)==u(i)),:);
end

%% Organize the labels by type in a containers.Map
instancesgrouped = containers.Map('KeyType', 'double','ValueType','any');
% Iterate all label types
for i=1:size(u,1)
    % Find all instances of that type
    instancesgrouped(u(i)) = instances(find(instances(:,3)==u(i)),:);
end



