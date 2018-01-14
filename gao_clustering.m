function CM = gao_clustering(feat_vec)

    options = [2.0; 100; 1e-5; 0];

    pixel_num = length(feat_vec);
    CM = zeros(pixel_num, 1);
    
    
    % feature vectors are divided into three categories by using FCM
    [center,U,obj_fcn] = fcm(feat_vec,3, options);
    
    maxU = max(U);
    index1 = find(U(1,:) == maxU);
    index2 = find(U(2,:) == maxU);
    index3 = find(U(3,:) == maxU);

    mean_1 = mean(feat_vec(index1));
    mean_2 = mean(feat_vec(index2));
    mean_3 = mean(feat_vec(index3));
    
    % Changed class is set to 1, 
    % unchanged class is set to 0
    % the intermediate class is set to 0.5
    if((mean_1<mean_2)&&(mean_2<mean_3))
        CM(index1) = 0.0; CM(index2) = 0.5; CM(index3) = 1.0;
    elseif((mean_1<mean_3)&&(mean_3<mean_2))
        CM(index1) = 0.0; CM(index2) = 1.0; CM(index3) = 0.5;
    elseif((mean_2<mean_1)&&(mean_1<mean_3))
        CM(index1) = 0.5; CM(index2) = 0.0; CM(index3) = 1.0;
    elseif((mean_2<mean_3)&&(mean_3<mean_1))
        CM(index1) = 1.0; CM(index2) = 0.0; CM(index3) = 0.5;
    elseif((mean_3<mean_2)&&(mean_2<mean_1))
        CM(index1) = 1.0; CM(index2) = 0.5; CM(index3) = 0.0;
    elseif((mean_3<mean_1)&&(mean_1<mean_2))
        CM(index1) = 0.5; CM(index2) = 1.0; CM(index3) = 0.0;
    end
    
end











