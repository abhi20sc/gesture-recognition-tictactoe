function [label,sx,so,sol,areaFrac,complex] = classify_gesture(frame, templX, templO)

bw = prep(frame);

sx = score_iou(bw, templX);
so = score_iou(bw, templO);

areaFrac = nnz(bw) / numel(bw);

stats = regionprops(bw, "Area", "Perimeter", "Solidity");

A = stats.Area;
P = stats.Perimeter;
sol = stats.Solidity;

if A == 0
    complex = 0;
else
    complex = (P^2) / (4*pi*A);
end

label = "UNKNOWN";

if so > 0.16 && (so - sx) > 0.08
    label = "O";
end

if sx > 0.22 && sx < 0.40 && (sx - so) > 0.10
    label = "X";
end



end
