
function  [SMs]=MSQF(f,M,N)
mu = unit(quaternion(1,1,1)); 
FL =  qfft2(f, mu, 'L') ./ sqrt(M*N);
A=abs(FL);
FL=FL./A;
A=log(1+fftshift(A));
for k=1:4
	Ak = imfilter(A, fspecial('gaussian',256,2^(k-2)));
	Ak=exp(fftshift(Ak))-1;
	FL_filted=Ak.*FL;
	FIL = iqfft2(FL_filted, mu, 'L') .* sqrt(M*N);
	FIL=abs(FIL);
	FIL = mat2gray(FIL);
	SMs(:,:,k)=FIL.^2;
end

