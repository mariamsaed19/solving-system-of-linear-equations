%Gauss Jordan
function[x,output]=GJ(A,B,perc)
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;
% AX = B >> find X
[n,~] = size(A);
A
B
% rank of matrix
Ab=[A B]; % Aug
rA=rank(A);
rAb=rank(Ab);
line=sprintf('Rank of A is %d and Rank of agumented A is %d',rA,rAb);
disp(line)
if rA==rAb
    if rA<n
        disp('The system has infinite number of solutions')
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

%set percision
digits(perc)

x = zeros(n,1); % initialize X >>> 0

% forward elimination
disp('Forward Elimination :')
for i=1 : n-1
    %pivoting
    index=i;
    for j=i+1:n
        %get the greatest coefficient of row
        greatest_coefficient=max(abs(A(j)));
        greatest_coefficient=max(greatest_coefficient,abs(B(j)));
        
        %get the max scaled row
        if abs(A(j,i)/greatest_coefficient) > abs(A(i,i)/greatest_coefficient)
            index=j;
        end
    end
    if index ~= i
        line=sprintf('R%d <---> R%d',i,index);
        disp(line)
        %swap rows in U
        [A(i,1:n),A(index,1:n)]=deal(A(index,1:n),A(i,1:n));
        %swap rows in b
        [B(i),B(index)]=deal(B(index),B(i));
        
        A
        B
    end
    
    m = vpa(A(i+1:n,i)/A(i,i));  % multiplier
    [k,~]=size(m);
    for j=1:k
        if isnan(m(j))
            continue;
        end
        line= sprintf('R%d <-- R%d - %0.4f * R%d',i+j,i+j,m(j),i);
        disp(line)
        A(i+j,:) = vpa(A(i+j,:) - (m(j)*A(i,:)))
        B(i+j,:) = vpa(B(i+j,:) - (m(j)*B(i,:)))
    end
    
    
end
A
B
% backward elimination
disp('Backward Elimination :')
for i=n : -1 : 2
    m = vpa(A(1:i-1,i)/A(i,i));  % multiplier
    [k,~]=size(m);
    for j=1:k
        if isnan(m(j))||isinf(m(j))
            continue;
        end
        line= sprintf('R%d <-- R%d - %0.4f * R%d',j,j,m(j),i);
        disp(line)
        A(j,:) = vpa(A(j,:) - (m(j)*A(i,:)))
        B(j,:) = vpa(B(j,:) - (m(j)*B(i,:)))
    end
    
    
end
% substitution
x=zeros(n,1);
disp('substitution : ')
for i=n :-1:1
    sum=0;
    %claculate remaining elments if the matrix is singular
    if rA<n
        for j=1:n
            sum=sum+x(j)*A(i,j);
        end
    end
    x(i,:) = vpa((B(i,:)-sum) / A(i,i));
    if isnan(x(i,:))
        line=sprintf('x%d is free variable, let x%d=1',i,i);
        disp(line)
        x(i,:)=1;
    end
    x
    A(i,:) = vpa(A(i,:) / A(i,i));
end
A
diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
end
