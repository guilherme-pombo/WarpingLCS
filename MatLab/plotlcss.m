function plotlcss(stream,template,w,px,py)

figure;

for i=1:length(stream)
    h=text(i,0,num2str(stream(i)));
    set(h,'HorizontalAlignment','center');
end
for i=1:length(template)
    h=text(0,i,num2str(template(i)));
    set(h,'HorizontalAlignment','center');
end

for y=1:size(w,1)
    for x=1:size(w,2)
        h=text(x,y,num2str(w(y,x)));
        set(h,'HorizontalAlignment','center');
    end
end

axis([-1 size(w,2)+1 -1 size(w,1)+1]);
set(gca,'YDir','reverse');

for y=2:size(w,1)
%for y=size(w,1):size(w,1)
   for x=2:size(w,2)
%    for x=size(w,2):size(w,2)
        %line([x-.25 py(y,x)+.25],[y-.25 px(y,x)+.25]);
        line([x py(y,x)],[y px(y,x)]);
    end
end

