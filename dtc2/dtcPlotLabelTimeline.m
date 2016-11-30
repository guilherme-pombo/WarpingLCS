%% dtcPlotLabelTimeline
% Plots the labels in row vector gt in a timeline.
% gt:       row vector (one line, n columns): gt(i) is the label of the ith frame or sample
% options:  structure comprising the following optional parameters:
%           options.labellinestyle:     Style of horizontal marking line
%           options.labellinewidth:     Width of horizontal marking line
%           options.labelcolor:         Color of horizontal marking line
%           options.linestyle:          Style of label plot
%           options.linewidth:          Width of label plot
%           options.color:              Color of label plot
%           options.marker:             Marker of label plot
%           options.markersize:         Marker size of label plot
%
% Options can easily be set as follows: 
%   dtcPlotLabelTimeline(gt,struct('labellinestyle','--', 'marker','o', ...,... ));

function dtcPlotLabelTimeline(gt,options)

%% Default parameters
% labellinestyle, labellinewidth: style of horizontal marking lines 
defaultlabellinestyle = '-';
defaultlabellinewidth = 0.5;
defaultlabelcolor = [.5 .5 .5];
% linestyle, linewidth: style of class plots
defaultlinestyle = '-';
defaultlinewidth = 0.5;
defaultmarker = 'none';
defaultmarkersize = 6;
defaultlinecolor = [0 0 0];

%% Parameter Checking
if ~exist('options','var') || ~isfield(options,'labellinestyle')
    labellinestyle = defaultlabellinestyle;
else
    labellinestyle = options.labellinestyle;
end
if ~exist('options','var') || ~isfield(options,'labellinewidth')
    labellinewidth = defaultlabellinewidth;
else
    labellinewidth = options.labellinewidth;
end
if ~exist('options','var') || ~isfield(options,'labelcolor')
    labelcolor = defaultlabelcolor;
else
    labelcolor = options.labelcolor;
end

if ~exist('options','var') || ~isfield(options,'linestyle')
    linestyle = defaultlinestyle;
else
    linestyle = options.linestyle;
end
if ~exist('options','var') || ~isfield(options,'linewidth')
    linewidth = defaultlinewidth;
else
    linewidth = options.linewidth;
end
if ~exist('options','var') || ~isfield(options,'markersize')
    markersize = defaultmarkersize;
else
    markersize = options.markersize;
end
if ~exist('options','var') || ~isfield(options,'marker')
    marker = defaultmarker;
else
    marker = options.marker;
end
if ~exist('options','var') || ~isfield(options,'linecolor')
    linecolor = defaultlinecolor;
else
    linecolor = options.linecolor;
end


%% Information about input data 
% Find the number of unique classes
u = unique(gt);
nu = size(u,2);

% x range of data
ns = size(gt,2);



%% Plot
%hf = figure;
hf = gcf;
% Plot horizontal lines for each label value
for i=1:nu
    h = line([0 ns-1],[i i]);
    set(h,'LineStyle',labellinestyle);
    set(h,'LineWidth',labellinewidth);
    set(h,'Color',labelcolor);
end

hold on;
% Plot each label kind i
for i=1:nu
    % li: indices of ground truth corresponding to ith label (can be discontinuous when there are multiple instances)
    li = find(gt==u(i));
    % find discontinuities
    instances = dtcFindTimeSeriesDiscontinuities(li,1);
    % Iterate all instances and plot them
    for j=1:size(instances,1)
        % instance length:
        instl = instances(j,2)-instances(j,1)+1;
        % instance 
        %[li(instances(j,1)):li(instances(j,2))]
        h = plot([li(instances(j,1))-1:li(instances(j,2))-1],ones(1,instl)*i);
        set(h,'LineStyle',linestyle);
        set(h,'LineWidth',linewidth);
        set(h,'Marker',marker);
        set(h,'MarkerSize',markersize);
        set(h,'Color',linecolor);
    end

    
    
end

% Various
ha = get(hf,'CurrentAxes');
box on;

% Set class ticks
yticklabel = cell(1,nu);
for i=1:nu
    yticklabel{i} = ['Class ' num2str(u(i))];
end
yticklabel{1} = 'Null class';
set(ha,'YTickLabel',yticklabel);
set(ha,'YTick',[1:nu]);

% Set the xrange of the plot
set(gca,'XLim',[0 ns-1]);

% Set the yrange of the plot
set(gca,'YLim',[0.5 nu+0.5]);



% Set legends
xlabel('i');
ylabel('Class');
title('Label timeline');


