function [ L ,U, X,output] = Crout( A, B , perc )
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;

%set percision
digits(perc)

n=size(A,1);
% rank of matrix
A
B
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
    L=[];
    U=[];
    X=[];
    return;
end

L=zeros(n);
U=zeros(n);
for i=1:n
    line=sprintf('compute L%d1 :',i);
    disp(line)
    L(i,1)= A(i,1)
    U(i,i)=1;
end

for i=2:n
    line=sprintf('compute U1%d :',i);
    disp(line)
    if L(1,1)==0
        line=sprintf('The pivot L11 is zero and can not calculate U1%d',i);
        disp(line)
        diary off;
        output=fileread('files');
        X=[];
        L=[];
        U=[];
        return;
    end
    U(1,i)=vpa(A(1,i)/L(1,1))
end
for i=2:n
    for j=2:i
        line=sprintf('compute L%d%d  :',i,j);
        disp(line)
        L(i,j)=vpa(A(i,j)-L(i,1:j-1)*U(1:j-1,j))
    end
    for j=i+1:n
        line=sprintf('compute U%d%d  :',i,j);
        disp(line)
        if L(i,i)==0
            line=sprintf('The pivot L%d%d is zero and can not calculate U%d%d',i,i,i,j);
            disp(line)
            diary off;
            output=fileread('files');
            X=[];
            L=[];
            U=[];
            return;
        end
        U(i,j)=vpa((A(i,j)-L(i,1:i-1)*U(1:i-1,j))/L(i,i))
    end
end

%foward
disp('Forward Substitution :')
k=length(B);
Y(1,1)=vpa(B(1)/L(1,1))
for i=2:k
    Y(i,1)=vpa((B(i)-L(i,1:i-1)*Y(1:i-1,1))/L(i,i))
end
%backward
disp('Backward Substitution :')
X=zeros(k,1);
X(k,1)=vpa(Y(k)/U(k,k));
if isnan(X(k,1))
    line=sprintf('x%d is free variable, let x%d=1',k,k);
    disp(line)
    X(k,1)=1;
end
X
for i=k-1:-1:1
    X(i,1)=vpa((Y(i,1)-U(i,i+1:k)*X(i+1:k,1))/U(i,i));
    if isnan(X(i,1))
        line=sprintf('x%d is free variable, let x%d=1',n,n);
        disp(line)
        X(i,1)=1;
    end
    X
end
diary off;
a=whos;
total_in_bytes=sum([a.bytes])
output=fileread('files');
end

