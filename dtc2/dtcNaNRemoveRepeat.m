%% dtcNaNRemoveRepeat
%
% Remove all the NaNs in the tim series by replacing them by the previous
% non-NaN value, or zero.
% 
% Input:
%       data:       a matrix of time series data; lines are samples, columns are
%                   data channels.
% Output:           the samme matrix of time series data without NaNs
%

function data2 = dtcNaNRemoveRepeat(data)

% Put a preliminary line of zero to solve the case of NaNs on the first
% line
data = [zeros(1,size(data,2));data];

% Remove NaNs
for c = 1:size(data,2)
    
    i=isnan(data(:,c));
    disc = dtcFindTimeSeriesDiscontinuities(i',0);
    for d=1:size(disc,1)
        if isnan(data(disc(d,1),c))
            %fprintf(1,'Col %d - Removing disc %d\n',c,d);
            data(disc(d,1):disc(d,2),c) = data(disc(d-1,2),c);
        end
    end
  
end

data2=data(2:end,:);