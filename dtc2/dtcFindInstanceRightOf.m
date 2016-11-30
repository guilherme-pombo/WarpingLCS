%% dtcFindInstanceRightOf
%
% Find the first instance which starts after the instance idx
%
% Input:
%   instances:          N by 3 matrix comprising [  i1start i1end   i1label;
%                                                   i2start i2end   i2label;
%                                                   ...     ...     ...
%                                                   iNstart iNend   iNlabel;]
%   idx:                Index of the instance from which we search from
%
% Output:
%   idxright:           Index of the instance right of idx, or empty vector
%                       if there is no instance to the right
%   instdist:           Distance from start of idxright to start of idx, or
%                       empty vector if there is no instance to the right
%
function [idxright,instdist] = dtcFindInstanceRightOf(instances,idx)

% Instance of interest
inst = instances(idx,:);

% Other instances
%instances = removerows(instances,'ind',idx);

% Find the first instance that starts after inst
inststart = inst(:,1);
delta = instances(:,1)-inststart;

% Find the smallest positive number
idxpos = find(delta>0);

% If there
if length(idxpos)==0
    idxright=[];
    instdist=[];
    return;
end


[instdist,i] = min(delta(idxpos));
% instdist: minimum distance from start to start
% i: index in delta(idxpos)
idxright = idxpos(i);

