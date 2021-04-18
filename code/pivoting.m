function [x,output]=pivoting(A,b,perc)
%Gauss Elimination with partial pivoting
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;
%set percision
digits(perc)

[n,~]=size(A);
nb=n+1; % size of Aug
Ab=[A b]; % Aug
A
b
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
        disp('The system has unique  solution')
    end
else
    disp('The system has No solution')
    diary off;
    output=fileread('files');
    x=[];
    return;
end

x=zeros(n,1); % initialize X >>> 0

% forward elimination
disp('Forward Elimination :')
for k=1 : n-1
    [big,i]=max(abs(Ab(k:n,k))/max(abs(Ab(k:n,k)))); % partial pivoting with scaling
    p=i+k-1;
    if p ~= k
        Ab([k,p],:)=Ab([p,k],:); % swap
        line=sprintf('R%d <--> R%d',k,p);
        disp(line)
        Ab
    end
    
    for i=k+1 : n
        m=vpa(Ab(i,k)/Ab(k,k)); % multiplier
        if isnan(m)
            continue;
        end
        line= sprintf('R%d <-- R%d - %0.4f * R%d',i,i,m,k);
        disp(line)
        Ab(i,k:nb)=vpa(Ab(i,k:nb) - m*Ab(k,k:nb))
    end
    
end

% back substitution
disp('Backward substitution : ')
x(n)=vpa(Ab(n,nb)/Ab(n,n)); % last one
if isnan(x(n))
    line=sprintf('x%d is free variable, let x%d=1',n,n);
    disp(line)
    x(n)=1;
end
x
for i = n-1:-1:1
    x(i,:)=vpa((Ab(i,nb) - (Ab(i,i+1:n)*x(i+1:n,:))) / (Ab(i,i)));
    if isnan(x(i,:))
        line=sprintf('x%d is free variable, let x%d=1',i,i);
        disp(line)
        x(i,:)=1;
    end
    x
end
Ab
diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
end