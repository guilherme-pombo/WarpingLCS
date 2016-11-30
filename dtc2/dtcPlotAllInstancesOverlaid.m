%% dtcPlotAllInstancesOverlaid
%
% Plots all instances of all classes in the dataset in a single plot. 
%
% Input:
%   dataset:        ns by nc matrix of ns samples of nc channels
%   instances:      a Map comprising the instances 
%   channel:        row vector indicate which channels to plot
%   transparent:    transparent plot
%   options:        structure comprising the following optional parameters:
%                   options.nolegend:       Set to anything to disable legend
%                   options.noxlabel:       Set to anything to disable xlabel
%                   options.noylabel:       Set to anything to disable ylabel
%                   options.notitle:        Set to anything to disable title
%                   options.noxtick:        Set to anything to disable xtick
%                   options.noytick:        Set to anything to disable ytick
%
function dtcPlotAllInstancesOverlaid(dataset, instances,channel,transparent,options)

%% Parameters
if ~exist('transparent','var')
    transparent = false;
end
if ~exist('options','var')
    options=struct;
end

if exist('options','var') && isfield(options,'notitle')
    notitle = 1;
else
    notitle = 0;
end

%% Setup
classes = cell2mat(instances.keys);
nclass = size(classes,2);
nrow = floor(sqrt(nclass));
ncol = ceil(nclass/nrow);



%% Plot
figure;


for i=1:nclass
    subplot(nrow,ncol,i);
    dtcPlotInstancesOverlaid(dataset,instances(classes(i)),channel,transparent,options);
    if ~notitle
        title(['Class ' num2str(classes(i))]);
    end
end

