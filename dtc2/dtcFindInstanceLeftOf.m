%% dtcFindInstanceLeftOf
%
% Find the first instance which starts before the instance idx
%
% Input:
%   instances:          N by 3 matrix comprising [  i1start i1end   i1label;
%                                                   i2start i2end   i2label;
%                                                   ...     ...     ...
%                                                   iNstart iNend   iNlabel;]
%   idx:                Index of the instance from which we search from
%
% Output:
%   idxleft:            Index of the instance left of idx, or empty vector
%                       if there is no instance to the left
%   instdist:           Distance from start of ifxleft to start of idx, or
%                       empty vector if there is no instance to the left
%
function [idxleft,instdist] = dtcFindInstanceLeftOf(instances,idx)

% Instance of interest
inst = instances(idx,:);

% Other instances
%instances = removerows(instances,'ind',idx);

% Find the first instance that starts before inst
inststart = inst(:,1);
delta = inststart-instances(:,1);

% Find the smallest positive number
idxpos = find(delta>0);

% If there
if length(idxpos)==0
    idxleft=[];
    instdist=[];
    return;
end


[instdist,i] = min(delta(idxpos));
% instdist: minimum distance from start to start
% i: index in delta(idxpos)
idxleft = idxpos(i);

