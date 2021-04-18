%Gauss Elimination without pivoting
function [x,output]=Gauss_Elimination(A,B,perc)
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;

% AX = B >> find X
[n,~] = size(A);
x = zeros(n,1); % initialize X >>> 0
%set percision
digits(perc);
% forward elimination
A
B
Ab=[A B]; % Aug
% rank of matrix
rA=rank(A);
rAb=rank(Ab);
line=sprintf('Rank of A is %d and Rank of agumented A is %d',rA,rAb);
disp(line)
if rA==rAb
    if rA<n
        disp('The system has infinite number of solutions')
        disp('Free variables will be considered 1 and find one solution of them')
    else
        disp('The system has unique solution')
    end
else
    disp('The system has No solution')
    diary off;
    output=fileread('files');
    x=[];
    return;
end

disp('Forward elimination :')
for i=1 : n-1
    m = vpa(A(i+1:n,i)/A(i,i));  % multiplier
    [k,~]=size(m);
    for j=1:k
        if isinf(m(j))
        
            line=sprintf('The pivot a%d%d is zero and can not solve the system',i,i);
            disp(line)
            diary off;
            output=fileread('files');
            return;
        end
        if isnan(m(j))
            continue;
        end
        line= sprintf('R%d <-- R%d - %0.4f * R%d',i+j,i+j,m(j),i);
        disp(line)
    end
    if isnan(m)
        continue;
    end
    A(i+1:n,:) = vpa(A(i+1:n,:) - (m*A(i,:)))
    B(i+1:n,:) =vpa( B(i+1:n,:) - (m*B(i,:)))
end

% back substitution
disp('Backward substitution : ')
x(n,:) = vpa(B(n,:) / A(n,n) ); % last one
if isnan(x(n,:))
    line=sprintf('x%d is free variable, let x%d=1',n,n);
    disp(line)
    x(n,:)=1;
end
x
for i=n-1 : -1 : 1
    x(i,:) = vpa((B(i,:) - (A(i,i+1:n)*x(i+1:n,:))) / (A(i,i)));
    if isnan(x(i,:))
        line=sprintf('x%d is free variable, let x%d=1',i,i);
        disp(line)
        x(i,:)=1;
    end
    x
end
diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
end
