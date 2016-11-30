%% dtcPerformanceF1
% Computes the F1 score between ground truth gt and the predicted classes y
% Input:
%   gt:     row vector comprising the grount truth label at each window or sample
%   y:      row vector comprising the predicted label at each window or sample
%   nid:    optional parameter indicating the null class id (to compute F1
%           without null)
% Ouput:
%   Structure comprising:
%       output.hits:    matrix comprising [class TP FP FN TN Prec Rec weight;
%                                           .... ];
%       ouptut.f1:      weighted f1 score for all classes including null
%       output.f1nn     weighted f1 score for without null class
%
%   Computing F1 without null class assumes that the null class is the one 
%   with the lowest id. 
%   If this is not the case, specify the id of the null class with nid.

function f1=dtcPerformanceF1(gt,y,nid)

% Check the unique classes
u = unique(gt);

hits=zeros(size(u,2),8);
% Computed for each class individually
for c = 1:size(u,2)
    % tp: positives (class c) predicted as positives (class c)
    tp = (gt==u(c)).*(y==u(c));     
    
    % fp: not positive (not class c) predicted as positives (class c)
    fp = (gt~=u(c)).*(y==u(c));
    
    % fn: not negative (class c) predicted as negative (not class c)
    fn = (gt==u(c)).*(y~=u(c));
    
    % tn (unused): negative (not class c) predicted as negative (not class c)
    tn = (gt~=u(c)).*(y~=u(c));

    prec = sum(tp)/(sum(tp)+sum(fp));
    rec = sum(tp)/(sum(tp)+sum(fn));
    w = sum(gt==u(c))/size(gt,2);
    
    hits(c,:) = [u(c) sum(tp) sum(fp) sum(fn) sum(tn) prec rec w];

end

% Compute sum 2*wi*preci*recalli /(preci+reci)
f1ind = 2*(prod(hits(:,6:8)')') ./ (sum(hits(:,6:7)')');
% address the case of NaNs arising when there are no true positives: set to
% 0 the individual f1 score
f1ind(find(isnan(f1ind)))=0;
f1.f1 = sum(f1ind);

if ~exist('nid','var')
    idx = 2:size(hits,1);
else
    idx = find(hits(:,1)~=nid);
end
f1.f1nn = sum(2*(prod(hits(idx,6:8)')') ./ (sum(hits(idx,6:7)')'));


f1.hits = hits;

