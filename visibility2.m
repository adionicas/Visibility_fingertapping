
function [k]=visibility(x)

n=length(x);
k=zeros(n,1);
for i=1:n-1
    k(i)=k(i)+1;k(i+1)=k(i+1)+1;
    m = x(i+1)-x(i);
    for j=(i+2):n
        new_m= (x(j)-x(i))/(j-i);
        if m<new_m
            m=new_m;
            k(i)=k(i)+1;k(j)=k(j)+1;
        end
    end
end
