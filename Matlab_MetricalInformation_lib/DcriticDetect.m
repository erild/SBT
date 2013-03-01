function Dcritic = DcriticDetect(maxIntra,minInter)

vect = maxIntra-minInter;

idx = find(vect<0);

if isempty(idx)     % ie no crossing
    Dcritic = max(maxIntra);
else
    Dcritic = maxIntra(idx(1));
end
