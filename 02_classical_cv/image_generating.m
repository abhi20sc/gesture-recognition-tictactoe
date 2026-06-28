cam = webcam(1);

outFolder = "dataset/one/testx";
mkdir(outFolder);

figure;
for i = 1
    frame = snapshot(cam);
    imshow(frame);
    title(i);

    filename = sprintf("random.png");
    imwrite(frame, fullfile(outFolder,filename));
    pause(0.1)
end

clear cam;

