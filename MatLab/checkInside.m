function [ inside, rowid ] = checkInside( ind, rangeList )
%CHECKINSIDE Check whether the ind appears in any range of indList
% Input:
% - ind: a positive interger value
% - rangeList: a matrix of rows formated as [start stop]
%
% Output: 
% -inside: boolean value. True if ind is inside any range of rangeList. 
%
% Long-Van Nguyen-Dinh
% ETH Zurich
% 14.03.2012 Initial version

inside = false;
for i = 1:size(rangeList,1)
    start = rangeList(i,1);
    stop = rangeList(i,2);
    if (ind <= stop & ind >= start)
        inside = true;
        rowid = i;
        return;
    end
end
end

