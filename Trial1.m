a=[];
cnt=0;
for i=1:5
    for j=1:10
        a(i,j)=cnt;
        cnt=cnt+1;
    end
end
n=3;

for i=1:5-n+1
    for j=1:10-n+1
        mb=a(i:(i+2),j:(j+2))
        mb=mb(:)
        x=median(mb)
    end
end