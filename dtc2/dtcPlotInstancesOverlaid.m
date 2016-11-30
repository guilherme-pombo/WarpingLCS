%% dtcPlotInstancesOverlaid
%
% Plots all the signal instances (possibly multiple channels) in a single plot.
%
% Input:
%   dataset:        ns by nc matrix of ns samples of nc channels
%   instances:      a N by 2 (or n by 3) matrix comprising the start/end of
%                   N the instances to plot.
%                   This matrix can be obtained with dtcFindInstancesFromLabelStream
%   channel:        row vector indicate which channels to plot
%   transparent:    transparent plot
%   options:        structure comprising the following optional parameters:
%                   options.nolegend:       Set to anything to disable legend
%                   options.noxlabel:       Set to anything to disable xlabel
%                   options.noylabel:       Set to anything to disable ylabel
%                   options.noxtick:        Set to anything to disable xtick
%                   options.noytick:        Set to anything to disable ytick
%

function dtcPlotInstancesOverlaid(dataset, instances, channel, transparent, options)
%% Error checks
if ~isrow(channel)
    error('channel must be a row vector');
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
    for j=1:nchannels
        if transparent
            l = dtcPlotTransparent([1:size(d,1)],d(:,j),alpha);
            set(l,'EdgeColor',cmap(j,:));
        else
            l = plot(d(:,j));
            set(l,'Color',cmap(j,:));
        end
        if i==1
            legends{j} = ['Channel ' num2str(channel(j))];
        end
    end
    
end

%% Apply parameters
if ~noxlabel
    xlabel('Samples');
end
if ~noylabel
    ylabel('Data');
end
if ~nolegend
    legend(legends);
end
if noxtick
    set(gca,'XTick',[])
end
if noytick
    set(gca,'YTick',[])
end

box on;



