function ST2 = RemoveDoubleSpikes(ST)

ST = sortrows(ST,[1:1:size(ST,2)]);

diffST = diff(ST);

if size(ST,2) == 4
    [tmpr,tmpc] = find(diffST(:,1)==0 & diffST(:,2)==0 & diffST(:,3)==0 & diffST(:,4)==0);
elseif size(ST,2) == 3
    [tmpr,tmpc] = find(diffST(:,1)==0 & diffST(:,2)==0 & diffST(:,3)==0);
end

ST2 = ST;
ST2(tmpr,:) = [];
