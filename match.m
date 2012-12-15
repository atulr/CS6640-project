function [matches, score] = match(I1, I2)
I1gs = rgb2gray(im2single(I1));
I2gs = rgb2gray(im2single(I2));

[F1, D1] = vl_sift(I1gs);
[F2, D2] = vl_sift(I2gs);
[matches score] = vl_ubcmatch(D1, D2, 1.5);
subplot(1,2,1);
    imshow(uint8(I1));
    hold on;
    plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'b*');

    subplot(1,2,2);
    imshow(uint8(I2));
    hold on;
    plot(F2(1,matches(2,:)),F2(2,matches(2,:)),'r*');