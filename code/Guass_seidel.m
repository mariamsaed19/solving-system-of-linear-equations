function [result,output] = Guass_seidel(A, b, initial, iter, error,perc)
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;
%set percision
digits(perc);
flag=1;
if sum(isnan(initial(:)))
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

 if size(initial,1)~=size(A,1)
    disp('size of initial guess does not match the size of the array')
    diary off;
    output=fileread('files');
    result=[];
    return;
 end
%initialize the table of errors
relative_error = zeros(size(A,1), iter+1);
relative_error(1) = 1 ;
x = initial;
k = 1;

A
b
x
while k <= iter && any(relative_error(:,k) > error)
    line=sprintf('\nIteration no#%d\n',k);
    disp(line)
    for i = 1:size(A,1)
        r = 0;
        for j = 1:size(A,1)
            if j~=i
                r = vpa(r + A(i,j) * x(j));
            end
        end
        temp = x(i);
        
        line=sprintf('Calculate X%d',i);
        disp(line)
        x(i) = vpa((1/A(i,i)) * (b(i,:) - r))
        relative_error(i,k+1) = vpa((x(i) - temp) / x(i));
        line=sprintf('Relative error of X%d = %0.4f ',i,relative_error(i,k+1));
        disp(line)
    end
    k = k + 1;
end
result = x
disp('Table of relative errors (rows represent the variables(x1 x2...xn) and columns represent the error in each iteration)')
relative_error=relative_error(:,2:iter+1)

diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
end