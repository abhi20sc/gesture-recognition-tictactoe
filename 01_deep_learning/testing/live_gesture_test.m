% load("gestureNet.mat", "trainedNet", "inputSize");
% 
% cam = webcam;
% 
% figure
% disp("Press Ctrl+C in Command Window to stop")
% 
% prevLabel = "";
% stableCount = 0;
% %stableLabel = "Other";
% 
% % Extra stability for Palm
% palmCount = 0;
% 
% % Confidence threshold
% minConf = 0.60;      % tune 0.50 to 0.75 if needed
% stableN = 3;         % normal stability frames
% palmStableN = 4;     % palm should be harder to trigger
% 
% while true
%     frame = snapshot(cam);
% 
%     % Resize and format for network
%     aug = augmentedImageDatastore(inputSize, frame, "ColorPreprocessing", "gray2rgb");
% 
%     % Predict
%     [label, scores] = classify(trainedNet, aug);
%     conf = max(scores);
% 
%     % If low confidence, treat as Other
%     % if conf < minConf
%     %     label = "Other";
%     % end
% 
%     % Normal stability for all labels
%     if label == prevLabel
%         stableCount = stableCount + 1;
%     else
%         stableCount = 1;
%         prevLabel = label;
%     end
% 
%     % Palm needs stricter stability
%     if label == "Palm"
%         palmCount = palmCount + 1;
%     else
%         palmCount = 0;
%     end
% 
%     % Update stableLabel
%     if label == "Palm"
%         if palmCount >= palmStableN
%             stableLabel = "Palm";
%         end
%     else
%         if stableCount >= stableN
%             stableLabel = label;
%         end
%     end
% 
%     % Display
%     imshow(frame)
%     title("Raw: " + string(label) + " (" + num2str(conf, "%.2f") + ")" + ...
%           "   Stable: " + string(stableLabel))
%     drawnow
% end
% 
% % After Ctrl+C, run:
% % clear cam


%% without other
load("gestureNet.mat", "trainedNet", "inputSize");

cam = webcam;

figure
disp("Press Ctrl+C in Command Window to stop")

prevLabel = "";
stableCount = 0;
stableLabel = "";

palmCount = 0;

stableN = 3;         
palmStableN = 4;     

while true
    frame = snapshot(cam);

    aug = augmentedImageDatastore(inputSize, frame, ...
        "ColorPreprocessing", "gray2rgb");

    [label, scores] = classify(trainedNet, aug);
    conf = max(scores);

    % Normal stability
    if label == prevLabel
        stableCount = stableCount + 1;
    else
        stableCount = 1;
        prevLabel = label;
    end

    % Extra stability for Palm
    if label == "Palm"
        palmCount = palmCount + 1;
    else
        palmCount = 0;
    end

    % Update stable label
    if label == "Palm"
        if palmCount >= palmStableN
            stableLabel = "Palm";
        end
    else
        if stableCount >= stableN
            stableLabel = label;
        end
    end

    imshow(frame)
    title("Raw: " + string(label) + ...
          " (" + num2str(conf, "%.2f") + ")" + ...
          "   Stable: " + string(stableLabel))
    drawnow
end
