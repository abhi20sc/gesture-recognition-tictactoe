imds = imageDatastore("data", ...
    "IncludeSubfolders", true, ...
    "LabelSource", "foldernames");

imds.Labels = categorical(imds.Labels);

% classOrder = ["F1","F2","F3","X","O","Palm","Other"];
classOrder = ["F1","F2","F3","X","O","Palm"];
imds.Labels = reordercats(imds.Labels, classOrder);

[imdsTrain, imdsVal] = splitEachLabel(imds, 0.8, "randomized");

net = resnet18;
inputSize = net.Layers(1).InputSize(1:2);

augTrain = augmentedImageDatastore(inputSize, imdsTrain, "ColorPreprocessing", "gray2rgb");
augVal   = augmentedImageDatastore(inputSize, imdsVal,   "ColorPreprocessing", "gray2rgb");

lgraph = layerGraph(net);
numClasses = numel(categories(imds.Labels));

lgraph = replaceLayer(lgraph, "fc1000", fullyConnectedLayer(numClasses, ...
    "Name", "fc1000", ...
    "WeightLearnRateFactor", 10, ...
    "BiasLearnRateFactor", 10));

lgraph = replaceLayer(lgraph, "ClassificationLayer_predictions", ...
    classificationLayer("Name", "ClassificationLayer_predictions"));

opts = trainingOptions("adam", ...
    "InitialLearnRate", 3e-4, ...
    "MaxEpochs", 6, ...
    "MiniBatchSize", 32, ...
    "Shuffle", "every-epoch", ...
    "ValidationData", augVal, ...
    "Verbose", true, ...
    "Plots", "training-progress");

trainedNet = trainNetwork(augTrain, lgraph, opts);

pred = classify(trainedNet, augVal);
acc = mean(pred == imdsVal.Labels);
disp("Validation accuracy: " + acc);

confusionchart(imdsVal.Labels, pred);

save("gestureNet.mat", "trainedNet", "inputSize", "classOrder");
