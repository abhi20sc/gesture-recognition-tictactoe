function bw = prep(img)

if size(img,3) == 3
    img = rgb2gray(img);
end

img = imgaussfilt(img,2);

bw = imbinarize(img,"adaptive","Sensitivity",0.585);

bw = imfill(bw,"holes");
bw = bwareaopen(bw,2000);
bw = imclose(bw, strel('disk',4));
bw = bwareafilt(bw,1);

bw = imresize(bw,[120 120]);

end