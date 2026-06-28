function s = score_iou(a,b)

a = logical(a);
b = logical(b);

inter = nnz(a&b);
uni = nnz(a|b);

if uni == 0
    s=0;
else
    s = inter/uni;
end
end
