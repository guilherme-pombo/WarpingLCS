%% dtcPlotSignalWindows
%
% Plots specified channels of the dataset, and highlight windows of data 
% within the dataset by a frame.
%
% Input:
%   dataset:        ns by nc matrix of ns samples of nc channels
%   instances:      a N by 2 (or n by 3) matrix comprising the start/end of
%                   N windows to highlight. 
%                   This matrix can be obtained with dtcFindInstancesFromLabelStream
%   channel:        row vector indicate which channels to plot
%   alpha:          transparency of the patches highlighting windows of data

function dtcPlotSignalWindows(dataset, instances, channel, alpha)

%% Parameter Checking
if ~exist('alpha','var')
    alpha = 0.1;
end


%% General info
nchannels=size(channel,2);
cmap = hsv(nchannels);
alpha = 1/size(instances,1);

%% Plot
hf = gcf;
hold on;


%% Iterate all the channels
for j=1:nchannels
%     if transparent
%         l = dtcPlotTransparent([1:size(d,1)],d(:,j),alpha);
%         set(l,'EdgeColor',cmap(j,:));
%     else
        l = plot(dataset(:,channel(j)));
        set(l,'Color',cmap(j,:));
%    end
    legends{j} = ['Channel ' num2str(channel(j))];
end

yl = get(gca,'YLim');
ylr = yl(2)-yl(1);

ylr

windowyshiftpercent = 0.01;
windowyshiftnum = 10;
windowyshiftctr = 0;

%% Iterate all the instances
for i=1:size(instances,1)
    % Create a patch
    y1 = yl(1)+ylr*windowyshiftpercent*windowyshiftctr;
    y2 = yl(2)-ylr*windowyshiftpercent*(windowyshiftnum-windowyshiftctr);
    y = [y1 y1 y2 y2];
    x=[instances(i,1) instances(i,2) instances(i,2) instances(i,1)];

    h = patch(x,y,'k');
    %,'FaceColor','none');
    set(h,'FaceAlpha',alpha);
    
%    l=patch(xflip, yflip, 'r', 'EdgeAlpha', alpha, 'FaceColor', 'none');
    windowyshiftctr = mod(windowyshiftctr+1,windowyshiftnum);
end


