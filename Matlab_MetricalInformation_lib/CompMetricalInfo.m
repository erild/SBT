function [ InformationVect,entropyCVect ] = CompMetricalInfo( bigD,all_stiMap,timeWindowVect,Dcritic )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

all_sti = unique(all_stiMap');
all_tri = [0:length(find(all_stiMap==all_stiMap(1)))-1]';
NbCases = length(all_sti)*length(all_tri);
TimeWindow = timeWindowVect(1);

entropyVect = [];
entropyCVect = [];
for time = timeWindowVect
    if iscell(bigD)
        D = bigD{time/TimeWindow};
    else
        D = squeeze(bigD(time/TimeWindow,:,:));
    end
    % computing entropy
    entropy = - sum(log2(sum(D<=Dcritic)/NbCases)/NbCases);
    entropyVect = [entropyVect,entropy];
    
    % computing conditional entropy
    entropyC = 0;
    for sti = all_sti'
        tmpr = find(all_stiMap==sti);
        entropyC = entropyC - sum(log2(sum(D(tmpr,tmpr)<=Dcritic)/length(all_tri)))/length(all_tri);
    end
    entropyCVect = [entropyCVect,entropyC/length(all_sti)];
end
InformationVect = entropyVect - entropyCVect;

end

