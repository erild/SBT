function [InformationVect,entropyCVect,timeWindowVect] = MainAnalysisFunc(InputFile,OutputFile,TimeStep,Cvp,Dcritic,LoadSavedFileYN,DisplayYN)
%
%   MainAnalysisFunc(InputFile,OutputFile,TimeStep,Cvp,Dcritic,LoadSavedFile)
%       Main function for launching analysis of spike trains with metrical
%       information (and Victor-Purpura distance)
%
%   Input Parameters :
%       InputFile       Path and Name of file containing spike trains to be
%                       loaded
%       OutputFile      Path and prefix of file where calculated
%                       cross-distance matrix will be saved
%       TimeStep        TimeStep used for calculating distances between
%                       Spike trains (ie time precision in analysis)
%                       in ms)
%       Cvp             Victor and Purpura cost for distance calculations (in ms^-1)
%       Dcritic         Critical Distance for similarity function in
%                       metrical information calculations (if Dcritic<0, then
%			then system will automatically detect optimal value)
%       LoadSavedFileYN Boolean :
%                       1 = load file "InputFile" (.mat file) containing
%			    distances instead of
%                           recalculating distances
%                       0 = load spike trains and redo all the calculations
%       DisplayYN       Boolean :
%                       1 = display results
%                       0 = do not display results
%
%   Output Parameters :
%	InformationVect	Vector of information (in bits)
%	entropyCVect	Vector of conditional entropy (in bits)
%	timeWindowVect	Vector of times (in ms)
%


if LoadSavedFileYN==0
    %% Loading Spike File
    InSpikesTMP = importdata(InputFile,' ');
    InSpikes = InSpikesTMP(:,1:4);                  % removing speeds (if necessary)
    
    all_sti = unique(InSpikes(:,1));                % extracting list of stimuli
    all_tri = unique(InSpikes(:,2));                % extracting list of trials
    LastSpikeTime = max(InSpikes(:,3));             % reading last spike time
    NbCases = length(all_sti)*length(all_tri);      % total number of spike train populations
    all_triMap = repmat(all_tri,length(all_sti),1)';    % returns trial flag of an element
    all_stiMap = reshape(repmat(all_sti,1,length(all_tri))',1,length(all_sti)*length(all_tri));     % returns the stimulus flag of an element
    
    
    %% Generating Distance Matrix
     InSpikes = RemoveDoubleSpikes(InSpikes);
    [ bigD,timeWindowVect ] = CompVPdistMat( InSpikes, TimeStep, Cvp );
    
    
    %% Extracting Min/Max Intra/Inter stimuli distance and correct classification rate
    [minInters,maxInters,minIntras,maxIntras,recTauxs] = ExtractDistMinMaxTau(bigD,all_stiMap,timeWindowVect);
    
    
    %% Saving Distance Matrix && Min/Max Intra/Inter stimuli distance
    disp([repmat(' ',1,15);repmat('-',1,15);repmat(' ',1,15)]);
    s = [OutputFile,'_VPcost',num2str(Cvp),'_timeStep',num2str(TimeStep),'.mat'];
    disp(['Saving Data to : ',s]);
    minInter = min(minInters);
    maxIntra = max(maxIntras);
    maxInter = max(maxInters);
    minIntra = min(minIntras);
    recTaux = mean(recTauxs);
    save(s,'bigD','minInter','maxInter','minIntra','maxIntra','timeWindowVect','all_stiMap','-v7.3');
    disp([repmat(' ',1,15);repmat('-',1,15);repmat(' ',1,15)]);
    
else
    %% Loading Saved File
    [bigD,minIntra,maxIntra,maxInter,minInter,timeWindowVect,all_stiMap] = LoadDistanceMatFile( InputFile );
end

if Dcritic<0
	Dcritic = DcriticDetect(maxIntra,minInter);
end
%% Calculating Metrical Information
[ InformationVect,entropyCVect ] = CompMetricalInfo( bigD, all_stiMap , timeWindowVect , Dcritic);

if DisplayYN==1
    %% Displaying results
    
    % distance matrix
%     figure,
%     imagesc(squeeze(bigD(end,:,:)));
    
    % Min/Max Intra/Inter stimuli distance
    figure,hold on,box on,
    plot(timeWindowVect,smooth(minInter,3),'b','linewidth',1.1);
    plot(timeWindowVect,smooth(maxInter,3),'b','linewidth',1.1);
    plot(timeWindowVect,smooth(maxIntra,3),'r','linewidth',1.1);
    plot(timeWindowVect,smooth(minIntra,3),'r','linewidth',1.1);
%     xlim([0 200]);
    xlabel('time (ms)');
    ylabel('distance');
    
    % Information & Conditional Entropy
    figure,hold on,box on,
    plot(timeWindowVect,smooth(InformationVect,3),'k','linewidth',1.1);
    plot(timeWindowVect,smooth(entropyCVect,3),'-- k','linewidth',2);
%     xlim([0 200]);
    xlabel('time (ms)');
    ylabel('information (bit)');
    drawnow
    
end
