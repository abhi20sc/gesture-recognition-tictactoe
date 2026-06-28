clc;
clear;
close all;

%% Load Dataset
datasetPath = 'RPSDataset/train';

imds = imageDatastore(datasetPath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

%% Split into training + validation
[imdsTrain, imdsVal] = splitEachLabel(imds, 0.8, 'randomized');

%% Load Pretrained Network (Transfer Learning)
net = resnet18;

inputSize = net.Layers(1).InputSize;

%% Replace Final Layers
lgraph = layerGraph(net);

numClasses = 3;

newLayers = [
    fullyConnectedLayer(numClasses, ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10)
    softmaxLayer
    classificationLayer];

lgraph = replaceLayer(lgraph, 'fc1000', newLayers(1));
lgraph = replaceLayer(lgraph, 'prob', newLayers(2));
lgraph = replaceLayer(lgraph, 'ClassificationLayer_predictions', newLayers(3));

%% Image Augmentation
imageAugmenter = imageDataAugmenter( ...
    'RandRotation',[-15 15], ...
    'RandXTranslation',[-10 10], ...
    'RandYTranslation',[-10 10]);

augTrain = augmentedImageDatastore(inputSize(1:2), imdsTrain, ...
    'DataAugmentation', imageAugmenter);

augVal = augmentedImageDatastore(inputSize(1:2), imdsVal);

%% Training Options
options = trainingOptions('adam', ...
    'MiniBatchSize', 32, ...
    'MaxEpochs', 5, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData', augVal, ...
    'ValidationFrequency', 10, ...
    'Verbose', false, ...
    'Plots','training-progress');

%% Train Network
trainedNet = trainNetwork(augTrain, lgraph, options);

%% Save Model
save('rpsModel.mat', 'trainedNet');

disp("Training Complete & Model Saved!");
