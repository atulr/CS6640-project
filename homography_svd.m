
function T = homography_svd(points1, points2)
% Matrix built as per http://www.vision.ee.ethz.ch/~bleibe/multimedia/teaching/cv-ws08/cv08-exercise05.pdf
A = zeros(size(points1, 2)*2, 9);
%     [points1, T1] = normalise2dpts(points1);
%     [points2, T2] = normalise2dpts(points2);

A(1:2:end,3) = 1;
A(2:2:end,6) = 1;

A(1, 1) = points1(1, 1);
A(1, 2) = points1(2, 1);
A(3, 1) = points1(1, 2);
A(3, 2) = points1(2, 2);
A(5, 1) = points1(1, 3);
A(5, 2) = points1(2, 3);
A(7, 1) = points1(1, 4);
A(7, 2) = points1(2, 4);

A(2, 4) = A(1, 1);
A(2, 5) = A(1, 2);
A(4, 4) = A(3, 1);
A(4, 5) = A(3, 2);
A(6, 4) = A(5, 1);
A(6, 5) = A(5, 2);
A(8, 4) = A(7, 1);
A(8, 5) = A(7, 2);

A(1, 7) =  -(points1(1, 1) * points2(1, 1));
A(2, 7) =  -(points1(2, 1) * points2(1, 1));
A(3, 7) =  -(points1(1, 2) * points2(1, 2));
A(4, 7) =  -(points1(2, 2) * points2(1, 2));
A(5, 7) =  -(points1(1, 3) * points2(1, 3));
A(6, 7) =  -(points1(2, 3) * points2(1, 3));
A(7, 7) =  -(points1(1, 4) * points2(1, 4));
A(8, 7) =  -(points1(2, 4) * points2(1, 4));

A(1, 8) =  -(points1(1, 1) * points2(2, 1));
A(2, 8) =  -(points1(2, 1) * points2(2, 1));
A(3, 8) =  -(points1(1, 2) * points2(2, 2));
A(4, 8) =  -(points1(2, 2) * points2(2, 2));
A(5, 8) =  -(points1(1, 3) * points2(2, 3));
A(6, 8) =  -(points1(2, 3) * points2(2, 3));
A(7, 8) =  -(points1(1, 4) * points2(2, 4));
A(8, 8) =  -(points1(2, 4) * points2(2, 4));

A(1, 9) =  -points2(1, 1);
A(2, 9) =  -points2(2, 1);
A(3, 9) =  -points2(1, 2);
A(4, 9) =  -points2(2, 2);
A(5, 9) =  -points2(1, 3);
A(6, 9) =  -points2(2, 3);
A(7, 9) =  -points2(1, 4);
A(8, 9) =  -points2(2, 4);


[U,S,V] = svd(A);

h = V(:,9) ./ V(9,9);

T = reshape(h,3,3);

% T = T2\T*T1;
% T = maketform('projective', x);

