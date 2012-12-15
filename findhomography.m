function H = findhomography(F1, F2, matches)
% result = 0;
% for i=1:100 % 100 iterations..
%     randVal = rand(1); %used to get 4 sets of values
%     randInd = floor(randVal * size(matches, 2));
%     if(randInd == 0)
%         randInd = 1;
%     end
%     
%     X1 = F1(1, matches(1,randInd));
%     Y1 = F1(2, matches(1,randInd));
%     X2 = floor(F2(1, matches(2,randInd)));
%     Y2 = floor(F2(2, matches(2,randInd)));
%     
%    H=[1 0 X2-X1;0 1 Y2-Y1;0 0 1];
%    count = 0; l = 1;
%     for j=1:size(matches, 2)
%        Hdash=H*[F1(1, matches(1, j)) F1(2, matches(1, j)) 1]';
%        
%        ssd=(F2(1, matches(2, j))-Hdash(1))^2+(F2(2, matches(2, j))-Hdash(2))^2;
%             if(ssd<0.6) 
%                 count=count+1;
%                 p(l,1)=F1(1, matches(1, j));
%                 p(l,2)=F1(2, matches(1, j));
% 				pprime(l,1)=F2(1, matches(2, j));
% 				pprime(l,2)=F2(2, matches(2, j));
%                 l=l+1;
%             end
%     end
%        if result<count
%           result=count;
%           Hprime=H;
%           p_inliers=p;
% 		  pprime_inliers=pprime;
%          
%        end    
% end
% 
% p_inliers(:,3)=1;
% pprime_inliers(:,3)=1;
% h=pprime_inliers\p_inliers;
% H=h';
X = ones(3, 4);
Y = ones(3, 4);
best_n_inliers = -1;
idx_best = zeros(5,1);
n_pts = 5;
it_improv={}; % saves the amount of inliers per improvment
n_iters = 500; % Iteration rule of thumb :)
F2r = zeros(size(F1, 1), size(F1, 2));
F2r(1:size(F2,1), 1:size(F2,2)) = F2;
for i = 1:n_iters
    for j = 1:4
        randVal = rand(1);
        randInd = floor(randVal * size(matches, 2));
        if(randInd == 0)
            randInd = 1;
        end
        X(1, j) = floor(F1(1, randInd));
        X(2, j) = floor(F1(2, randInd));
        Y(1, j) = floor(F2(1, randInd));
        Y(2, j) = floor(F2(2, randInd));
    end
    
    H2D = homography2d(X, Y);
    T = maketform('projective',H2D');
    [TF1x TF1y] = tformfwd(T, F1(1, :), F1(2, :));
    distXsq = (TF1x - F2r(1,:)).^2;
    distYsq = (TF1y - F2r(2,:)).^2;
    n_inliers=0;
    for k=1:length(distXsq)
        e=sqrt(distXsq(k)+distYsq(k));
        if e <= 2.0 % inlier radius in px
            n_inliers=n_inliers+1;
        end
    end
    
    % improvment check
    if n_inliers > best_n_inliers
        best_n_inliers = n_inliers;
        T_im1 = T;
        H1 = H2D;
%         idx_best = idxs;
    end
end



% disp(it_improv);

% best_pts=zeros(length(idx_best),4);
% best_pts(:,[1 2])=F1(:, idx_best);
% best_pts(:,[3 4])=F2(:, idx_best);

disp('foo');
disp(H1);
H = T_im1;

