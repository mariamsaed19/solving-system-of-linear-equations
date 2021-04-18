
function [L,U,x,output] = solveChelosky(A,b,perc)

clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;
%set percision
digits(perc)
%A is the coefficient matrices
%B is a column vector

[L,U] = Cholesky(A,perc);
if isempty(L) || isempty(U) %check if non-symmetric
    x = [];
    diary off;
    output=fileread('files');
    return
end
[n,r] = size(b);
x = zeros(n,1);
y = zeros(n,1);
%backward sub
for i=1:1:n
    if (i==1)
        y(1)= vpa(b(1)/L(1,1));
    else
        sum=0;
        for j=1:1:i-1
            sum = vpa(sum + L(i,j)*y(j));
        end
        y(i) = vpa((b(i)-sum)/L(i,i));
    end
end

%forward sub
for i=n:-1:1
    if (i==n)
        x(n)= vpa(y(n)/U(n,n));
    else
        sum=0;
        for j=i+1:1:n
            sum = vpa(sum + U(i,j)*x(j));
        end
        x(i) = vpa((y(i)-sum)/U(i,i));
        if isnan(x(i))
            line=sprintf('x%d is free variable, let x%d=1',n,n);
            disp(line)
            x(i)=1;
        end
        x
    end
end
diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
return;
