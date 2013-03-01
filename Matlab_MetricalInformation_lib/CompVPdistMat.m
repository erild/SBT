function [ bigD,timeWindowVect ] = CompVPdistMat( InSpikes, TimeWindow, Cvp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Extracting Number of Stimuli && trials
all_sti = unique(InSpikes(:,1));
all_tri = unique(InSpikes(:,2));
LastSpikeTime = max(InSpikes(:,3));
NbCases = length(all_sti)*length(all_tri);
all_triMap = repmat(all_tri,length(all_sti),1)';
all_stiMap = reshape(repmat(all_sti,1,length(all_tri))',1,length(all_sti)*length(all_tri));


%% Generating Spike Vectors and Dist Matrix
timeWindowVect = [TimeWindow:TimeWindow:ceil(LastSpikeTime/TimeWindow)*TimeWindow];         % vector of time window limits
% bigD = zeros(length(timeWindowVect),NbCases,NbCases);                                       % matrix to save Distance Matrix at each time
bigD = cell(1,length(timeWindowVect));

disp(' ');
for time = timeWindowVect
    disp(['Time : ',num2str(time)]);
    % loading all spikes in time window
    tmp_spikes = InSpikes(InSpikes(:,3)<time,:);                      % extracts all spikes before time index
    D = zeros(NbCases,NbCases);
    if(~isempty(tmp_spikes))
        MRvect = unique(tmp_spikes(:,4))';                            % finds all MR that are spiking
        % running through Mechanoreceptors
        for MR = MRvect
            tmpSpikes2 = tmp_spikes(tmp_spikes(:,4)==MR,:);           % extracts all spikes of a MR
            stime = [];
            sstart = [];
            send = [];
            for sti = all_sti'                                        % reformats data for spkdl (mex) funtion
                for tri = all_tri'
                    sstart = [sstart,length(stime)+1];
                    stime = [stime,tmpSpikes2(tmpSpikes2(:,1)==sti & tmpSpikes2(:,2)==tri,3)'];
                    send = [send,length(stime)];
                end
            end
            d = spkdl(stime,sstart,send,Cvp);
            D = D + reshape(d,NbCases,NbCases);
        end
    else
        D = zeros(NbCases,NbCases);                                   % actually not necessary
    end
%         imagesc(D);
%         drawnow;
    bigD{time/TimeWindow} = D;
end



end

