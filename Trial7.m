[row,col]=size(Z1);
 fid=fopen('F:\workspace\MathModel\recognize\Z1.txt','wt');
for i=1:row
    for j=1:col
        fprintf(fid,'%d ', Z1(i,j));
    end
    fprintf(fid,'\n');
end