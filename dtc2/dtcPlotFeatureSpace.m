%% dtcPlotFeatureSpace
%
% Feature space visualization of the feature vector fvect and class label lvect
%   
% Input:
%   fvect:      nf x ni matrix (column: instances; row: features)
%   lvect:      row vector with the label of the feature vector
%
% Note that specific code path are followed for 1D, 2D and 3D feature
% vectors. No visualization is possible for feature vectors with more 
% than 3 dimensions.


function dtcPlotFeatureSpace(fvect,lvect)

% Three cases: 1, 2, 3D

if size(fvect,1)==1
    dtcPlotFeatureSpace1D(fvect,lvect);
elseif size(fvect,1)==2
    dtcPlotFeatureSpace2D(fvect,lvect);
elseif size(fvect,1)==3
    dtcPlotFeatureSpace3D(fvect,lvect);
else
    error('Cannot visualize more than 3D feature vectors');
end
