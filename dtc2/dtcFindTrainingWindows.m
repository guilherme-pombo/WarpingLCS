%% dtcFindTrainingWindows
% Find the range of the training windows "close" to an instance
%
% Training windows are sliding windows of size wsize around the data instances, 
% in the range [InstStart-MaxLeft:InstEnd+MaxRight].
%
% If no window of size wsize fits (i.e. InstEnd-InstStart<wsize), then a single
% training window is created according to the 'Align' parameter.
% 
% No window may be created if the window size is larger than the size of
% the data.
% 
% Null class: this function receives all the 'instances' in the dataset but
% has no understanding of "null" class. 
% If the instances which are passed include null class instances 
% immediately prior and after the instance of interest, the function logic
% will never generate training windows overlapping the null class (unless 
% the training window is larger than the instance of interest, in which 
% mcase the training window is aligned on the instance according to
% 'Align').
% If training windows should slide prior/after the instance of interest, 
% then the null class instances must be removed before calling this 
% function.
%
% Input:
%   instances:      N by 3 matrix comprising [  i1start i1end   i1label;
%                                               i2start i2end   i2label;
%                                               ...     ...     ...
%                                               iNstart iNend   iNlabel;]
%   instidxofinterest:  Index within 'instances' of the instance around 
%                   which to create training windows
%   datasize:       size of the data, to ensure windows don't go beyond
%   MaxRight:       training windows can take up sample more recent than
%                   the last sample of the instance up to MaxRight
%                   samples
%   MaxLeft:        training windows can take up sample older than the
%                   first sample of the instance up to MaxLeft samples
%   wsize:          window size
%   wstep:          window stepping
%   Align:          if there is no window of size wsize that fits the instance, 
%                   a single window wsize is created which is aligned right (+1)
%                   of the instance, centered on the instance (0), or
%                   aligned left (-1)
%
%                |(4)|(2)|       | (1)|   | (3)|
% GroundTruth |JJ|       |IIIIIII|             |JJJJJJJJJ|
% Windows:                         |--| 
%                                |--|
%                              |--|
%                            |--|
%                          |--|
%                        |--|
%                      |--|
%                    |--|
% (1): MaxRight
% (2): MaxLeft
% (3): GuardPreDiff (or GuardPreSame)
% (4): GuardPostDiff (or GuardPostSame)
%

function candidatewindows=dtcFindTrainingWindows(instances,instidxofinterest,datasize,wsize,wstep,Align,MaxRight,MaxLeft,GuardPreSame,GuardPostSame,GuardPreDiff,GuardPostDiff)
inst = instances(instidxofinterest,:);
candidatewindows=[];

%% Get neighbors
% Find the nearest neighbors of that instance....
% What if overlapping instances ???

% Right neighbor: start-end positive and closer to zero
[nri,nrd] = dtcFindInstanceRightOf(instances,instidxofinterest);
fprintf(1,'Right instance idx %d dist %d type %d. [%d:%d]\n',nri,nrd,instances(nri,3),instances(nri,1),instances(nri,2));

% Left neighbor: start-end positive and closer to zero

[nli,nld] = dtcFindInstanceLeftOf(instances,instidxofinterest);
fprintf(1,'Left instance idx %d dist %d type %d. [%d:%d]\n',nli,nld,instances(nli,3),instances(nli,1),instances(nli,2));

%% Find limits
% rightlimit and leftlimit are inclusive limits
% 
% Find limit on the right: righmost sample
if isempty(nri)
    rightlimit = inst(2) + MaxRight;
else
    if instances(nri,3) == inst(3)
        rightlimit = min(inst(2)+MaxRight,instances(nri,1)-GuardPreSame-1);
    else
        rightlimit = min(inst(2)+MaxRight,instances(nri,1)-GuardPreDiff-1);
    end
end
% Find limit on the left: leftmost sample
if isempty(nli)
    leftlimit = inst(1) - MaxLeft;
else
    if instances(nli,3) == inst(3)
        leftlimit = max(inst(1)-MaxLeft,instances(nli,2)+GuardPostSame+1);
    else
        leftlimit = max(inst(1)-MaxLeft,instances(nli,2)+GuardPostDiff+1);
    end
end
fprintf(1,'Instance limits: [%d;%d] type %d\n',inst(1),inst(2),inst(3));
fprintf(1,'Before clamping. Left limit: %d Right limit: %d\n',leftlimit,rightlimit);

%% Clamp limits
% Clamp limits if they are pushed within an instance (e.g. because of large 
% guard) or is outside of bounds
if rightlimit<inst(2)
    rightlimit=inst(2);
end
if leftlimit>inst(1)
    leftlimit=inst(1);
end
if leftlimit < 1
    leftlimit=1;
end
if rightlimit>datasize
    rightlimit=datasize;
end

fprintf(1,'After clamping. Left limit: %d Right limit: %d\n',leftlimit,rightlimit);

%% Special case when the limits are smaller than window size
if rightlimit-leftlimit<wsize-1
    fprintf(1,'Special case\n');
    
    % Place the window based on the alignment
    if Align == 0
        leftlimit = floor((inst(2)+inst(1))/2-wsize/2);
        rightlimit = leftlimit+wsize-1;
    elseif Align == +1
        rightlimit = inst(2);
        leftlimit = rightlimit-wsize+1;
    elseif Align == -1
        leftlimit = inst(1);
        rightlimit = leftlimit+wsize-1;
    end
    % Clamp, clamping may overrun the data
    if leftlimit<1
        leftlimit = 1;
        rightlimit = leftlimit+wsize-1;
    end
    if rightlimit>datasize;
        rightlimit=datasize;
        leftlimit = rightlimit-wsize+1;
    end
    % Add the window only if the window is within the data
    if leftlimit>=1 && rightlimit<=datasize
        candidatewindows=[candidatewindows; leftlimit rightlimit inst(3)];
    end    
else
%% Normal case
% Slide a window within leftlimit;rightlimit inclusive
    fprintf(1,'Normal case\n');

    for i = leftlimit:wstep:rightlimit-wsize+1
        candstart = i;
        candend = i+wsize-1;
        candidatewindows=[candidatewindows; candstart candend inst(3)];
    end
end



