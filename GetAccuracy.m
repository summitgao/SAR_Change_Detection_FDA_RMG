function  [FP,FN,OE,PCC]=GetAccuracy(refImage,tstImage)
%-------------------------------------------------------------------------
% Usage: [FA,MA,OE] = GetAccuracy(refImage,testImage)
% Inputs:
%   refImage=reference map
%   testImage=detection map
% Outputs:
%   FP=False positives
%   FN=False negatives
%   OE=Overall Error
%-------------------------------------------------------------------------
if isempty(refImage)
    error('!!!Not exist reference map');
end

refImage(find(refImage>=128))=255;
refImage(find(refImage<128))=0;

RI=refImage(:);
TI=tstImage(:); 


aa=find(RI==0&TI~=0);
bb=find(RI~=0&TI==0);

FP=numel(aa);
FN=numel(bb);
OE=FP+FN; 
[m,n]=size(tstImage);
PCC = 1-OE/(m*n);
