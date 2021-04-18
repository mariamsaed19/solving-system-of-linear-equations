function [result,output] = Jacobi(A, b, intial, iter, error,perc)
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;
%set percision
digits(perc);
%initialize the table of errors
flag=1;
if sum(isnan(intial(:)))
    disp('Wrong format of initial guess')
    flag=2;
end
if isnan(iter)
    disp('Wrong format of number of iterations')
    flag=2;
end
if isnan(error)
    disp('Wrong format of relative error')
    flag=2;
end
if flag==2
        diary off;
    output=fileread('files');
    result=[];
    return;
end
 if size(intial,1)~=size(A,1)
    disp('size of initial guess does not match the size of the array')
    diary off;
    output=fileread('files');
    result=[];
    return;
 end
relative_error = zeros(size(A,1), iter+1);
relative_error(1) = 1 ;
x = zeros(size(A,1));
x(:,1) = intial;
k = 1;
A
b
intial
while k <= iter && any(relative_error(:,k) > error)
    line=sprintf('\nIteration no#%d\n',k);
    disp(line)
    for i = 1:size(A,1)
        r = 0;
        for j = 1:size(A,1)
            if j ~= i
                r = vpa(r + A(i,j) * x(j,k));
            end
        end
        line=sprintf('Calculate X%d',i);
        disp(line)
        x(i,k+1) = vpa((1/A(i,i)) * (b(i,:) - r));
        x(:,k+1)
        relative_error(i,k+1) = vpa((x(i,k+1) - x(i,k)) / x(i,k+1));
        line=sprintf('Relative error of X%d = %0.4f ',i,relative_error(i,k+1));
        disp(line)
    end
    k = k + 1;
end
result = x(:,k)
disp('Table of relative errors (rows represent the variables(x1 x2...xn) and columns represent the error in each iteration)')
relative_error=relative_error(:,2:iter+1)
diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
end