%{
解軌道上の点が線形独立なベクトルになっていることをたしかめる
%}
size_unclassified = size(unclassified);
size_classified = size(classified);
check_num = [7];
cos = 0;
for i=1: length(check_num)
    j = check_num(i);
    A = unclassified(:,:,j);
    x0 = [1,1]';
    x1 = expm(A*0.1)*x0;
    x20 = expm(A*2.0)*x0;
    cos = cos+dot(x1/norm(x1), x20/norm(x20));
end
ave_cos_unclassified = cos/length(check_num);

cos=0;
for i=1: size_classified(1,3)
    A = classified(:,:,i);
    x0 = [1,1]';
    x1 = expm(A*0.1)*x0;
    x20 = expm(A*2.0)*x0;
    cos = cos+dot(x1/norm(x1), x20/norm(x20));
end
ave_cos_classified = cos/size_classified(1,3);