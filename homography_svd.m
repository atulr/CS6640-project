
function T = homography_svd(points1, points2)

% based on http://www.robots.ox.ac.uk/~vgg/presentations/bmvc97/criminispaper/node3.html
n = 4;
x = points2(1, :); y = points2(2,:); X = points1(1,:); Y = points2(2,:);
rows0 = zeros(3, n);
rowsXY = -[X; Y; ones(1,n)];
hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];
[U, ~, ~] = svd(h);
v = (reshape(U(:,9), 3, 3)).';
T = v;

