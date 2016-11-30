%% dtcPlotFeatureSpace1D
%
% Visualize the a 1D row feature vector fvect 
%
%
%
%
function dtcPlotFeatureSpace1D(fvect,lvect)

if ~isrow(fvect)
    error('fvect must be a row vector');
end

%% Find unique labels
u = unique(lvect);



%% Plot
%hf = figure;
hf = gcf;

hold on;

% Generate a color map
cmap = hsv(size(u,2));

for i=1:size(u,2)
    f = fvect(:,lvect==u(i));
    [p,xi] = ksdensity(f);
    l = plot(xi,p);
    set(l,'Color',cmap(i,:));
    legends{i} = ['Class ' num2str(u(i))];
end
legend(legends);
xlabel('Feature value');
ylabel('Probability density function');