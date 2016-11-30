%% dtcPlotFeatureSpace2D
%
% Feature space visualization of the feature vector fvect and class label lvect
%   
% Input:
%   
%
function dtcPlotFeatureSpace2D(fvect,lvect)

if size(fvect,1) ~= 2
    error('fvect must be a 2 by n matrix');
end

%% Find unique labels
u = unique(lvect);



%% Plot
%hf = figure;
hf = gcf;

hold on;

% Generate a color map
cmap = hsv(size(u,2));

for j=1:2
    for i=1:size(u,2)
        f = fvect(:,lvect==u(i));

        if j==1
            % Plot an ellipse (assuming some normal distribution
            rx=std(f(1,:))*3;
            ry=std(f(2,:))*3;
            cx=mean(f(1,:));
            cy=mean(f(2,:));
            t=-pi:0.01:pi;
            x=cx+rx*cos(t);
            y=cy+ry*sin(t);
            l=plot(x,y);
            set(l,'Color',cmap(i,:));
            legends{i} = ['Class ' num2str(u(i))];
            
            
        else
            % Plot a dot
            l = plot(f(1,:),f(2,:),'.');
            set(l,'Color',cmap(i,:));
        end

        

        
    end
end
legend(legends);
xlabel('Feature 1');
ylabel('Feature 2');

box on;


% f = fvect(:,lvect==u(1));
% % Estimate a continuous pdf from the discrete data
% [pdfx xi]= ksdensity(f(1,:));
% [pdfy yi]= ksdensity(f(2,:));
% 
% % Create 2-d grid of coordinates and function values, suitable for 3-d plotting
% [xxi,yyi]     = meshgrid(xi,yi);
% [pdfxx,pdfyy] = meshgrid(pdfx,pdfy);
% 
% % Calculate combined pdf, under assumption of independence
% pdfxy = pdfxx.*pdfyy; 
% 
% % Plot the results
% mesh(xxi,yyi,pdfxy)
% set(gca,'XLim',[min(xi) max(xi)])
% set(gca,'YLim',[min(yi) max(yi)])

