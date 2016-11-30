%% dtcFindTimeSeriesDiscontinuities
% This function can be used for two purposes
%   1)  Label mode: find the start/end of each instance in a time series, 
%       where the time series contains the label of 
%   2)  Timestamp mode: find the start/end of continous segments in a time 
%       series assumed to increase by 1 at each time step
% Input:
%   ts:       row vector containing the time series data. Either labels, or
%   delta:    For (1) pass delta=0. For (2) pass delta=1.
% Output:   
%   Nx2 matrix: [ s1start s1end;
%                s2start s2end;
%                ...
%                sNstart sNend]
% 
function inst = dtcFindTimeSeriesDiscontinuities(ts,delta)
inst=[];
% find discontinuities
disc = find(ts(2:end)-ts(1:end-1) ~= delta);
disc = [0 disc size(ts,2)];

for i=1:size(disc,2)-1
    inst=[inst;disc(i)+1 disc(i+1)];
end

