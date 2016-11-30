function [lcstable,prevx,prevy] = spottingWLCS2( template,series,penalty)
% Use Warping LCSS 1 Algorithm to do spotting
% INPUT:
% - template: an activity template
% - series: continuous activity timeseries
% - threshold: decide which local optimal points are likely to represent
% where the activity occurs.
% - dist = the matrix of distances between two arbitrary data points in 
% timeseries. For example, given two data points x,y, the distance between
% them is dist(x,y).
% - delta
% OUTPUT:
% the matrix with row format [start_time stop_time]

% 2012 Long-Van Nguyen-Dinh

hasDist = 0;
acceptedDist=2;
M = length(template);
N = length(series);

template = [template(1) template];
series = [series(1) series];

lcstable = zeros(M+1, N+1);
prevx = zeros(M+1, N+1);
prevy = zeros(M+1, N+1);

% Find LCS using dynamic programming
for i=1:M,
    for j = 1:N,
        if abs(template(i+1) - series(j+1)) <= acceptedDist
            lcstable(i+1,j+1) = lcstable(i,j) + 1;
            prevx(i+1,j+1) = i;
            prevy(i+1,j+1) = j;
        else
            p1 =  lcstable(i,j) - abs(template(i+1) - series(j+1)) * penalty;
            p2 = lcstable(i,j+1) - abs(template(i) - template(i+1)) * penalty;
            p3 = lcstable(i+1,j) - abs(series(j) - series(j+1)) * penalty;
            [x,pos] = max([p1,p2,p3]);
            lcstable(i+1,j+1) = x;
            if pos == 1
                prevx(i+1,j+1) = i;
                prevy(i+1,j+1) = j;
            elseif pos == 2
                prevx(i+1,j+1) = i;
                prevy(i+1,j+1) = j+1;
            else
                prevx(i+1,j+1) = i+1;
                prevy(i+1,j+1) = j;
            end
        end
    end
end


