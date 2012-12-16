function H = findhomography(F1, F2, matches)

X = ones(2, 4);
Y = ones(2, 4);
best_n_inliers = -1;
idx_best = zeros(5,1);
n_pts = 5;
it_improv={}; % saves the amount of inliers per improvment
n_iters = 500; % Iteration rule of thumb :)
F2r = zeros(size(F1, 1), size(F1, 2));
F2r(1:size(F2,1), 1:size(F2,2)) = F2;
worst = 9999999999999;



X1 = F1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
X2 = F2(1:2,matches(2,:)) ; X2(3,:) = 1 ;


numMatches = size(matches,2) ;

bestBad = 9999999999999;
for t=1:100
   
    subset = vl_colsubset(1:numMatches, 4) ;

    for j = 1:4
        randVal = rand(1);
        randInd = floor(randVal * size(matches, 2));
        
        if(randInd == 0)
            randInd = 1;
        end
        X(1, j) = floor(F1(1, matches(1, randInd)));
        X(2, j) = floor(F1(2, matches(1, randInd)));
        Y(1, j) = floor(F2(1, matches(2, randInd)));
        Y(2, j) = floor(F2(2, matches(2, randInd)));
    end

    H = homography_svd(X, Y);
    X(3, :) = 1;
    Y(3, :) = 1;
    count = 0;
    X2P = H' * X ;
    du = X2P(1,:)./X2P(3,:) - Y(1,:)./Y(3,:) ;
    dv = X2P(2,:)./X2P(3,:) - Y(2,:)./Y(3,:) ;
    
    if((du.*du + dv.*dv) < 6*6 )
        
      count = count + 1;  
    end
    
    if bestBad > count
        disp('here');
        bestH = H;
        bestBad = count;
    end
end




% disp(bestH);
% for i = 1:n_iters
%     
%     for j = 1:4
%         randVal = rand(1);
%         randInd = floor(randVal * size(matches, 2));
%         
%         if(randInd == 0)
%             randInd = 1;
%         end
%         X(1, j) = floor(F1(1, matches(1, randInd)));
%         X(2, j) = floor(F1(2, matches(1, randInd)));
%         Y(1, j) = floor(F2(1, matches(2, randInd)));
%         Y(2, j) = floor(F2(2, matches(2, randInd)));
%     end
%     T = homography_svd(X, Y);
% % H2D = Y * pinv(X);
% %     T = maketform('projective',H2D');
% %     check this bit..
%     
%     result = 0;
%     for k = 1:length(matches)
%         transformed = T * [F1(1:2, matches(1,k));1];
%         actual = [F2(1:2,matches(2, k));1];
%         
% %         disp(dot((transformed - actual), (transformed - actual)));
%         if (dot((transformed - actual), (transformed - actual)) < 36)
%             
%             result = result + 1;
%         end
%     end
%     
%     
% %     [TF1x TF1y] = tformfwd(T, F1(1, matches(1, :)), F1(2, matches(1, :)));
% %     distXsq = (TF1x - F2(1, matches(2, :))).^2;
% %     distYsq = (TF1y - F2(2,matches(2, :))).^2;
% %     n_inliers=0;
%     
%       
% %       disp(F3T);
%       
% %     disp(dist);
% %     for k=1:length(distXsq)
% %         e = sqrt(distXsq(k) + distYsq(k));
% %         
% %         if e <= 2.0 % inlier radius in px
% %             
% %             n_inliers=n_inliers+1;
% %         end
% %     end
%     
% %     disp(n_inliers);
%     % improvment check
%     disp(result);
%     if worst > result
%         disp(result);
%         worst = result;
%         T_im1 = T;
%         
% 
% %         H1 = H2D;
% %         idx_best = idxs;
%     end
% end





% best_pts=zeros(length(idx_best),4);
% best_pts(:,[1 2])=F1(:, idx_best);
% best_pts(:,[3 4])=F2(:, idx_best);

% disp('foo');
% disp(H1);
% disp(H);


