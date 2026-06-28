cam = webcam;

label = "Palm";               % "O", "Palm", "Other", "F1", "F2", "F3"
numBase = 30;              % how many original captures
numAugPerBase = 4;         % how many augmented images per capture
pauseTime = 0.001;

folder = fullfile("data", label);
if ~exist(folder, "dir")
    mkdir(folder);
end

% Preview frame to set crop box
frame0 = snapshot(cam);
[h,w,~] = size(frame0);

cropW = round(0.50 * w);
cropH = round(0.60 * h);
x0 = round((w - cropW)/2);
y0 = round((h - cropH)/2);
cropRect = [x0 y0 cropW cropH];

figure

for i = 1:numBase
    frame = snapshot(cam);

    imshow(frame)
    hold on
    rectangle("Position", cropRect, "EdgeColor", "g", "LineWidth", 2);
    hold off
    title("Keep hand in box. Capturing " + "5." + label + "  (" + i + "/" + numBase + ")")
    drawnow

    cropImg = imcrop(frame, cropRect);

    % Save original crop
    baseName = "5." + label + "_" + i;
    imwrite(cropImg, fullfile(folder, baseName + "_base.png"));

    % Save augmented versions
    for k = 1:numAugPerBase
        augImg = simpleAugment(cropImg);
        imwrite(augImg, fullfile(folder, baseName + "_aug" + k + ".png"));
    end

    pause(pauseTime);
end

clear cam
disp("Done")

function out = simpleAugment(img)
% Implements approx of:
% RandRotation [-35 35]
% RandXTranslation [-20 20]
% RandYTranslation [-20 20]
% RandScale [0.9 1.1]
% RandXReflection true

img = im2uint8(img);

% Random reflection
if rand < 0.5
    img = fliplr(img);
end

% Random rotation
ang = -35 + 70*rand;

% Random scale
sc = 0.9 + 0.2*rand;

% Random translation
tx = -20 + 40*rand;
ty = -20 + 40*rand;

% Affine transform
T = [ sc*cosd(ang)  -sc*sind(ang)   0
      sc*sind(ang)   sc*cosd(ang)   0
      tx             ty             1 ];

tform = affine2d(T);

% Warp and keep same output size
ref = imref2d(size(img));
warped = imwarp(img, tform, "OutputView", ref);

% Fill any empty pixels by simple inpainting style
% Replace black borders by nearest valid data using a mild blur fallback
mask = all(warped == 0, 3);
if any(mask(:))
    blurred = imgaussfilt(warped, 1);
    warped(repmat(mask,1,1,size(warped,3))) = blurred(repmat(mask,1,1,size(warped,3)));
end

out = warped;
end
