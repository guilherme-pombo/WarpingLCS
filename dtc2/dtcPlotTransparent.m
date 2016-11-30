%% dtcPlotTransparent
%
% Primitive replacement of the plot function to draw plots with 
% transparent lines.
% 
% Input:
%   x:      x vector
%   y:      y vector
%   alpha:  transparency
% Output:   handle to the Matlab patch corresponding to the drawn line
%   
% Internally the plot is realized with a a patch. 
% To change color use the returned handles, and set(l,'EdgeColor',....)

function l=dtcPlotTransparent(x,y,alpha)

%% Ensures we have row vectors
if ~isrow(x)
    x=x';
end
if ~isrow(x)
    error('x must be a vector');
end
if ~isrow(y)
    y=y';
end
if ~isrow(y)
    error('y must be a vector');
end


xflip = [x(1 : end - 1) fliplr(x)];

yflip = [y(1 : end - 1) fliplr(y)];

l=patch(xflip, yflip, 'r', 'EdgeAlpha', alpha, 'FaceColor', 'none');


