
function e=entropy1(p);

[H,W]=size(p);
z=p;
z=p/sum(p(:));
Ker=fspecial('gaussian',256,ceil(W/4));
Ker=Ker/max(Ker(:));
z=z.*Ker;
z=sum(z(:));
p=double(p);
sgm=W*.02;
p = imfilter(p, fspecial('gaussian',round(4*sgm),sgm));
p=mat2gray(p);
p=p*255;
p=uint8(p);
e=entropy(p)/z;

