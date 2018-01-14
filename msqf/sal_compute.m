
% Source file to obtain the saliency map of the input difference image
% Author: Feng Gao
% Date : 2017/04/23

function SalMap = sal_compute(SmoothingValue, inImg)

    [ylen,xlen,c]=size(inImg);
    inImg = imresize(inImg, [256, 256], 'bilinear');

    % Compute input feature maps
    r = inImg(:,:,1);g = inImg(:,:,2);b = inImg(:,:,3);   
    I = mean(inImg,3);I=max(max(r,g),b);
    R = r-(g+b)/2;G = g-(r+b)/2;B = b-(r+g)/2;
    Y = (r+g)/2-abs(r-g)/2-b;Y(Y<0) = 0;
    RG = double(R - G);BY =double(B - Y);

    % Compute the Hypercomplex representation
    f = quaternion(RG, BY, I);
    clear B BY G I R RG Y;

    % Compute the Scale space in frequency domain
    [M,N]=size(r);S=MSQF(f,M,N);
    clear b c g r;

    % Find the optimal scale
    sgm=xlen*SmoothingValue;
    for k=1:4 
          entro(k)=entropy1((S(:,:,k)));
    end
    entro_seq=sort(entro); c=find(entro==entro_seq(1));c=c(1);
    SalMap=mat2gray(S(:,:,c));
    for k=1:4
        SalMap_k = imfilter(S(:,:,k), ...
            fspecial('gaussian',[round(4*sgm) round(4*sgm)],sgm));
    end

    clear M N S SalMap_k entro entro_seq f inImg k c;

    sgm=xlen*SmoothingValue;
    SalMap = imfilter(SalMap, fspecial('gaussian', ...
        [round(4*sgm) round(4*sgm)],sgm));
    SalMap = imresize(SalMap, [ylen,xlen], 'bilinear');

end