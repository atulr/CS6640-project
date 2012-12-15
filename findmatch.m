function [M, S] = findmatch(D1, D2)


% try own algorithm after homography
% indices = zeros(size(D1, 2));
% distance = zeros(size(D1, 2), 1);

% for i=1:size(D1, 2)
%     for j=1:size(D2, 2)
%         distance(j) = sum((D1(:, i) - D2(:, j)) .^ 2);
%     end
%     
%     [val ind] = sort(distance);
%     if(val(1) < 1.5 * val(2))
%         c = c+1;
%         indices(i) = ind(1);
%     end
% end
% disp(matches);
