
%======================================================
% The files are the MATLAB source code for the paper:
% 
% Feng Gao, Xiao Wang, Junyu Dong, Shengke Wang.
% 
% Synthetic aperture radar image change detection based on 
% frequencydomain analysis and random multigraphs
% 
% Journal of Applied Remote Sensing. 12(1), 016010 (2018).
% 
% The demo has not been well organized. 
% Please contact me if you meet any problems.
% 
% Email: gaofeng@ouc.edu.cn
%=======================================================



clear; clc;

addpath('./msqf/');
addpath('./rmg/');




%========== basic parameters =============
SmoothVal = 0.01;
PatSize = 5;
t_sal = 0.1;
%=========================================

im1   = imread('./pic/san_1.bmp');
im2   = imread('./pic/san_2.bmp');
im_gt = imread('./pic/san_gt.bmp');

im1   = double(im1(:,:,1));  
im2   = double(im2(:,:,1)); 
im_gt = double(im_gt(:,:,1));

% obtain the difference image
fprintf(' ... ... compute the difference image ... ...\n');
im_di = di_gen(im1, im2);
im_di = mat2gray(im_di)*255;
im_di(:,:,2)=im_di(:,:,1); im_di(:,:,3)=im_di(:,:,1);



% compute the saliency map of the difference image
sal_map = sal_compute(SmoothVal, im_di);
sal_map = mat2gray(sal_map);
sal_map = double(sal_map > t_sal);

% find salient region
sal_idx = find(sal_map==1);
feat_vec = im_di(sal_idx);
fprintf(' ... ... clustering for sample selection begin ... ...\n');
feat_lab = gao_clustering(feat_vec);
fprintf(' ... ... clustering for sample selection finished !!!!\n');

clear i feat_vec SmoothVal;

% 获取 lab 信息
pos_idx = find(feat_lab == 1);
neg_idx = find(feat_lab == 0);
mid_idx = find(feat_lab == 0.5);

[ylen, xlen] = size(im1);

% 图像周围填零，然后每个像素周围取Patch，保存
mag = (PatSize-1)/2;
imTmp = zeros(ylen+PatSize-1, xlen+PatSize-1);
imTmp((mag+1):end-mag,(mag+1):end-mag) = im1; 
im1 = im2col_general(imTmp, [PatSize, PatSize]);
imTmp((mag+1):end-mag,(mag+1):end-mag) = im2; 
im2 = im2col_general(imTmp, [PatSize, PatSize]);
clear imTmp mag;
% 合并样本到 im
im1 = mat2imgcell(im1, PatSize, PatSize, 'gray');
im2 = mat2imgcell(im2, PatSize, PatSize, 'gray');
parfor idx = 1 : numel(im1)
    im_tmp = [im1{idx}; im2{idx}];
    im(idx, :) = im_tmp(:);
end
clear im1 im2 idx;

% 取出显著性区域的特征
im = im(sal_idx, :);


Dim = PatSize*PatSize*2;
kg = 2;
% 使用 random multi-graph 训练与测试
fprintf(' ... ... Graph number:%d ... ...\n', kg);
kf = floor(Dim/4);
% 得到训练样本在整体样本集中的 index
label_index = [pos_idx; neg_idx];
% 整个样本集的 groud truth index
labels = reshape(im_gt(sal_idx), length(sal_idx), 1) / 255 + 1;
labels(mid_idx) = 1;
[G,F]  = MultiGraphs(im,labels,label_index,kg,kf);


% obtain the classification results
[val, predict_res]=max(F,[],2);
predict_res = predict_res-1;

res = zeros(ylen, xlen);
for i = 1:length(sal_idx)
    res(sal_idx(i)) = predict_res(i);
end

[FP,FN,OE,PCC] = GetAccuracy(im_gt, res);
% save the results
fid = fopen('rec.txt', 'a');
fprintf(fid, 'ta = %f\n', t_sal);
fprintf(fid, 'PatSize = %d\n', PatSize);
fprintf(fid, 'FP: %d \n', FP);
fprintf(fid, 'FN: %d \n', FN);
fprintf(fid, 'OE: %d \n', OE);
fprintf(fid, 'PCC:   %f \n\n\n', PCC);
fclose(fid);

fprintf(' ===== Written change detection results to Res.txt ====\n\n');









