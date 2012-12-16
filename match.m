function [matches, score] = match(I1, I2)
I1gs = im2single(rgb2gray(I1));
I2gs = im2single(rgb2gray(I2));

[F1, D1] = vl_sift(I1gs);
[F2, D2] = vl_sift(I2gs);

[matches score] = vl_ubcmatch(D1, D2, 1.5);
HM = findhomography(F1, F2, matches);
disp(HM);

Tr = maketform('projective', inv(HM'));

% init masks
mask_im2 = uint8(ones(size(I2,1),size(I2,2)));


mask_im1 = uint8(ones(size(I1, 1), size(I1, 2)));
% 
% % Transform image 2 so it fits on image 1


[I3, XDATA, YDATA] = imtransform(I2, Tr, 'XYScale', 1);
mask_im2 = imtransform(mask_im2, Tr);
disp(size(I2, 1));
disp(size(I2, 2));
disp(XDATA);
disp(YDATA);

% stitched image bounds
W=max( [size(I1,2) size(I1,2)-XDATA(1) size(I2,2) size(I2,2)+XDATA(1)] );
H=max( [size(I1,1) size(I1,1)-YDATA(1) size(I2,1) size(I2,1)+YDATA(1)] );

% Align image 1 bounds
im1_X = eye(3);
if XDATA(1) < 0, im1_X(3,1)= -XDATA(1); end
if YDATA(1) < 0, im1_X(3,2)= -YDATA(1); end
T_im1 = maketform('affine',im1_X);

[im1, XDATA2, YDATA2] = imtransform(I1, T_im1, 'XData', [1 W], 'YData', [1 H]);
mask_im1 = imtransform(mask_im1, T_im1, 'XData', [1 W], 'YData', [1 H]);

% Align image 2 bounds 
im2_X = eye(3);
if XDATA(1) > 0, im2_X(3,1)= XDATA(1); end
if YDATA(1) > 0, im2_X(3,2)= YDATA(1); end
T_im2 = maketform('affine',im2_X);

[I2, XDATA, YDATA] = imtransform(I2, T_im2, 'XData', [1 W], 'YData', [1 H]);
mask_im2 = imtransform(mask_im2, T_im2, 'XData', [1 W], 'YData', [1 H]);

% Size check
if (size(im1,1) ~= size(I2,1)) || (size(I1,2) ~= size(I2,2))
    H = max( size(I1,1), size(I2,1) );
    W = max( size(I1,2), size(I2,2) );
    I1(H,W,:)=0;
    I2(H,W,:)=0;
    mask_im1(H,W)=0;
    mask_im2(H,W)=0;
end

% Combine both images
n_layers = max(max(mask_im1));
im1part = uint16(mask_im1 > (n_layers * mask_im2));
im2part = uint16(mask_im2 > mask_im1);

combpart = uint16(repmat(mask_im1 .* mask_im2,[1 1 3]));
combmask = uint16(combpart > 0);

stitched_image = repmat(im1part,[1 1 3]) .* uint16(im1) + repmat(im2part,[1 1 3]) .* uint16(I2);
stitched_image = stitched_image + ( combpart .* uint16(im1) + combmask .* uint16(I2) ) ./ (combpart + uint16(ones(size(combpart,1),size(combpart,2),3)));
stitched_image = uint8(stitched_image);
stitched_mask = mask_im1 + mask_im2;


subplot(2,2,3); imshow(I1);
subplot(2,2,4); imshow(I2);

fH=figure;
axis off;
movegui(fH, 'east');
imshow(stitched_image);
% box2 = [1  size(I2,2) size(I2,2)  1 ;
%         1  1           size(I2,1)  size(I2,1) ;
%         1  1           1            1 ] ;
% box2_ = inv(HM) * box2 ;
% box2_(1,:) = box2_(1,:) ./ box2_(3,:) ;
% box2_(2,:) = box2_(2,:) ./ box2_(3,:) ;
% ur = min([1 box2_(1,:)]):max([size(I1,2) box2_(1,:)]) ;
% vr = min([1 box2_(2,:)]):max([size(I1,1) box2_(2,:)]) ;
% 
% [u,v] = meshgrid(ur,vr) ;
% 
% im1_ = vl_imwbackward(im2double(I1),u,v);
% z_ = HM(3,1) * u + HM(3,2) * v + HM(3,3) ;
% u_ = (HM(1,1) * u + HM(1,2) * v + HM(1,3)) ./ z_ ;
% v_ = (HM(2,1) * u + HM(2,2) * v + HM(2,3)) ./ z_ ;
% im2_ = vl_imwbackward(im2double(I2),u_,v_) ;
% mass = ~isnan(im1_) + ~isnan(im2_) ;
% im1_(isnan(im1_)) = 0 ;
% im2_(isnan(im2_)) = 0 ;
% mosaic = (im1_ + im2_) ./ mass ;
% 
% figure(2) ; clf ;
% imagesc(mosaic) ; axis image off ;
% title('Mosaic') ;
end

