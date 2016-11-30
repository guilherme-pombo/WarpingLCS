function [out,val,lcstable] = spottingWLCS2( template,series,acceptedDist,penalty,threshold,dist)
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

if nargin < 5 ,
    disp('[out,D] = spottingWLCS2( template,series,acceptedDist,penalty,threshold,[dist])');
end
hasDist = 1;
if nargin < 6
    hasDist = 0;
end
M = length(template);
N = length(series);

template = [template(1) template];
series = [series(1) series];

lcstable = zeros(M+1, N+1);
prevx = zeros(M+1, N+1);
prevy = zeros(M+1, N+1);

% Find LCS using dynamic programming
if(hasDist == 0) % distance between two symbols (numbers) is the difference
    % between two numbers themselves.
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
else
    for i=1:M,
        for j = 1:N,
            if dist(template(i+1),series(j+1)) <= acceptedDist
                lcstable(i+1,j+1) = lcstable(i,j) + 1;
                prevx(i+1,j+1) = i;
                prevy(i+1,j+1) = j;
            else
                p1 = lcstable(i,j) - dist(template(i+1),series(j+1)) * penalty;
                p2 = lcstable(i,j+1) - dist(template(i),template(i+1)) * penalty;
                p3 = lcstable(i+1,j) - dist(series(j),series(j+1)) * penalty;
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
end

% Get rid of initial conditions
lcstable = lcstable(2:end, 2:end);
prevx = prevx(2:end, 2:end)-1;
prevy = prevy(2:end, 2:end)-1;

% spotting
out = [];
val = [];
[ymax,imax,ymin,imin] = extrema(lcstable(end,:)); clear ymin; clear imin;

spotidx = find(ymax >= threshold);
i = length(spotidx);
while i >= 1 ;
    stop = imax(spotidx(i));
    if (checkInside(stop, out))
        i = i - 1;
        continue;
    end 
    % trace back to find start point
    n = stop;
    m = M;
    lcss = 0;
    while (m>=1 & n>1) % trace back the path
        newm = prevx(m,n);
        if(newm == 0)
            break;
        end
        newn = prevy(m,n);
        if(newm == m - 1 & newn == n - 1)
            lcss = lcss + 1;
        end
        m = newm;
        n = newn;
    end
    start = n;
    out = [out; [start stop]];    
    % val = [val;ymax(spotidx(i))/threshold];
    % val = [val;ymax(spotidx(i))/max(length(template), (stop - start + 1))]; % normalize
    val = [val;lcss / max(length(template), (stop - start + 1))]; % normalize
    i = i - 1;
end
end