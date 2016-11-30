%% dtcPlotInstancesScatterOverlaid
%
% Scatter plots of the signal instances (x,y channels) in a single plot.
%
% Input:
%   dataset:        ns by nc matrix of ns samples of nc channels
%   instances:      a n by 2 (or n by 3) matrix comprising the start/end of
%                   the instance of interest
%   channel:        row vector indicate which channels (x,y) to plot
%   transparent:    transparent plot
%   options:        structure comprising the following optional parameters:
%                   options.nolegend:       Set to anything to disable legend
%                   options.noxlabel:       Set to anything to disable xlabel
%                   options.noylabel:       Set to anything to disable ylabel
%                   options.noxtick:        Set to anything to disable xtick
%                   options.noytick:        Set to anything to disable ytick
%
function dtcPlotInstancesScatterOverlaid(dataset, instances, channel, transparent, options)
%% Error checks
if size(channel)~=[1 2]
    error('channel must be a row vector with exactly 2 channels');
end
%% Parameters
if ~exist('transparent','var')
    transparent=false;
end
if exist('options','var') && isfield(options,'nolegend')
    nolegend = 1;
else
    nolegend = 0;
end
if exist('options','var') && isfield(options,'noxlabel')
    noxlabel = 1;
else
    noxlabel = 0;
end
if exist('options','var') && isfield(options,'noylabel')
    noylabel = 1;
else
    noylabel = 0;
end
if exist('options','var') && isfield(options,'noxtick')
    noxtick = 1;
else
    noxtick = 0;
end
if exist('options','var') && isfield(options,'noytick')
    noytick = 1;
else
    noytick = 0;
end

%% General info
nchannels=size(channel,2);
cmap = hsv(nchannels);
alpha = 1/size(instances,1);

%% Plot
hf = gcf;
hold on;

%% Iterate all the instances
for i=1:size(instances,1)
    % Data subset with only the instance samples and channels of interest
    d = dataset(instances(i,1):instances(i,2),channel);
    if transparent
        l = dtcPlotTransparent(d(:,1),d(:,2),alpha);
    else
        l = plot(d(:,1),d(:,2)); 
    end
end

%% Apply parameters
if ~noxlabel
    xlabel(['Channel ' num2str(channel(1))]);
end
if ~noylabel
    ylabel(['Channel ' num2str(channel(2))]);
end
if noxtick
    set(gca,'XTick',[])
end
if noytick
    set(gca,'YTick',[])
end

box on;

