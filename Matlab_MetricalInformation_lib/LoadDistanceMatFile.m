function [D,minIntra2,maxIntra2,maxInter2,minInter2,timeWindowVect2,all_stiMap2] = LoadDistanceMatFile( FileString )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    load(FileString);
    D = bigD;
    minInter2 = minInter;
    maxInter2 = maxInter;
    maxIntra2 = maxIntra;
    minIntra2 = minIntra;
    timeWindowVect2 = timeWindowVect;
    all_stiMap2 = all_stiMap;
    
end

