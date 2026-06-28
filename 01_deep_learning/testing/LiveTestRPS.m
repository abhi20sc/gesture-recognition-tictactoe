clc;
clear;
close all;

%% Load trained model
load('rpsModel.mat', 'trainedNet');

%% Start webcam
cam = webcam;

% Get network input size
inputSize = trainedNet.Layers(1).InputSize;

%% Create display window
hFig = figure('Name','Live RPS Test','NumberTitle','off');

% Optional: improve responsiveness
set(hFig, 'KeyPressFcn', @(~,e) assignin('base','keyPressed',e.Key));
keyPressed = ""; %#ok<NASGU>

disp("Live test running. Press 'q' in the figure window to quit.");

while ishandle(hFig)

    % Grab frame
    frame = snapshot(cam);

    % Resize for network
    frameResized = imresize(frame, inputSize(1:2));

    % Predict
    [label, scores] = classify(trainedNet, frameResized);

    % Get confidence (%)
    conf = max(scores) * 100;

    % Show camera feed (original size looks nicer)
    imshow(frame);
    hold on;

    % Overlay prediction
    txt1 = sprintf("Prediction: %s", string(label));
    txt2 = sprintf("Confidence: %.1f%%", conf);

    text(20, 40, txt1, 'Color','yellow','FontSize',20,'FontWeight','bold');
    text(20, 80, txt2, 'Color','cyan','FontSize',16,'FontWeight','bold');

    hold off;
    drawnow;

    % Quit if user pressed q
    if evalin('base','exist("keyPressed","var")')
        kp = evalin('base','keyPressed');
        if strcmpi(kp, 'q')
            break;
        end
    end
end

%% Cleanup
clear cam;
if ishandle(hFig), close(hFig); end
disp("Live test stopped.");
