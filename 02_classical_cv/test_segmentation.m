img = imread("dataset/1/one/one_001.png");
img = imgaussfilt(img,2);

gray = rgb2gray(img);
bw = gray < 120;

bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 2000);

bw = bwareafilt(bw,1);

figure;
subplot(1,3,1), imshow(img), title("Original");
subplot(1,3,2), imshow(gray), title("Grayscale");
subplot(1,3,3), imshow(bw), title("Hand mask");
%%
blob = vision.BlobAnalysis("MinimumBlobArea", 1500, "BoundingBoxOutputPort", true, "CentroidOutputPort", true);
[~, centroid, bbox] = blob(bw);

if isempty(bbox)
    disp("No hand detected");
    return
end

imgCenter = size(bw)/2;

dist = vecnorm(centroid - imgCenter(1:2), 2, 2);
[~,idx] = min(dist);

hand = imcrop(bw, bbox(idx,:));

rowsWithHand = find(any(hand,2));
topRow = rowsWithHand(1);
bottomRow = rowsWithHand(end);
handOnly = hand(topRow:bottomRow, :);

h = size(handOnly,1);
handTop = hand(1:round(0.45*h),:);

figure;
imshow(hand);
title("Cropped hand");
%%
colSum = sum(handTop,1);
colSum = movmean(colSum,10);

[pks, ~] = findpeaks(colSum,"MinPeakHeight", 0.5*max(colSum), "MinPeakDistance", 40);

numFingers = numel(pks);
disp("Detected fingers: " + numFingers)
figure;
plot(colSum);
title("Projection Profile")
