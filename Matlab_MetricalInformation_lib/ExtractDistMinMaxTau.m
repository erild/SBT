function [minInters,maxInters,minIntras,maxIntras,recTauxs] = ExtractDistMinMaxTau( bigD,all_stiMap,timeWindowVect )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

all_sti = unique(all_stiMap');
all_tri = [0:length(find(all_stiMap==all_stiMap(1)))-1]';
TimeWindow = timeWindowVect(1);

minInters = [];
maxInters = [];
minIntras = [];
maxIntras = [];
recTauxs = [];

for time = timeWindowVect
    tmpmaxIntra = [];
    tmpmaxInter = [];
    tmpminIntra = [];
    tmpminInter = [];
    tmprecTaux = [];
    if iscell(bigD)
        Dtemp = bigD{time/TimeWindow} + max(max(bigD{time/TimeWindow}))*eye(size(bigD{time/TimeWindow},2));
        Dtemp2 = bigD{time/TimeWindow};
    else
        Dtemp = squeeze(bigD(time/TimeWindow,:,:)) + max(max(bigD(time/TimeWindow,:,:)))*eye(size(bigD(time/TimeWindow,:,:),2));
        Dtemp2 = squeeze(bigD(time/TimeWindow,:,:));
    end
    
    for sti=all_sti'
        tmprInter = find(all_stiMap~=sti);
        tmpr = find(all_stiMap==sti);
%         tmpmaxIntra = [tmpmaxIntra; max(max(bigD(time/TimeWindow,tmpr,tmpr)))];
%         tmpminInter = [tmpminInter; min(min(bigD(time/TimeWindow,tmpr,tmprInter)))];
%         tmpminIntra = [tmpminIntra; min(min(bigD(time/TimeWindow,tmpr,tmpr)))];
%         tmpmaxInter = [tmpmaxInter; max(max(bigD(time/TimeWindow,tmpr,tmprInter)))];
        tmpmaxIntra = [tmpmaxIntra; max(max(Dtemp2(tmpr,tmpr)))];
        tmpminInter = [tmpminInter; min(min(Dtemp(tmpr,tmprInter)))];
        tmpminIntra = [tmpminIntra; min(min(Dtemp(tmpr,tmpr)))];
        tmpmaxInter = [tmpmaxInter; max(max(Dtemp2(tmpr,tmprInter)))];
        

        [C,I] = min(Dtemp(:,tmpr));

        for i=1:length(I)
            tmppr = find(Dtemp(:,tmpr(i))==C(i));
            if(length(tmppr)>1 && sum(all_stiMap(tmppr)~=sti)>0)
                if sti==0
                    I(i)=length(all_tri)+1;
                else
                    I(i)=1;
                end
            end
        end
        tmprecTaux = [tmprecTaux;sum(all_stiMap(I)==sti)/(length(all_tri))];
    end

    minInters = [minInters,tmpminInter];
    maxIntras = [maxIntras,tmpmaxIntra];
    maxInters = [maxInters,tmpmaxInter];
    minIntras = [minIntras,tmpminIntra];
    recTauxs = [recTauxs,tmprecTaux];
end

end

