function [L,U,x,output]=Downlittle(matrix,b,perc)
clc
if exist('files', 'file') ; delete('files'); end
diary('files')
diary on;

%set percision
digits(perc)
%initialize L  as Identity matrices
[a]=size(matrix,1);
% rank of matrix
matrix
b
Ab=[matrix b]; % Aug
rA=rank(matrix);
rAb=rank(Ab);
line=sprintf('Rank of A is %d and Rank of agumented A is %d',rA,rAb);
disp(line)
if rA==rAb
    if rA<a
        disp('The system has infinite number of solutions')
        disp('Free variables will be considered 1 and find one solution of them')
    else
        disp('The system has unique  solution')
    end
else
    disp('The system has No solution')
    diary off;
    output=fileread('files');
    L=[];
    U=[];
    x=[];
    return;
end

L=eye(a);
U=matrix;
disp('Computing L and U')
for i=1:a
    %pivoting
    index=i;
    for j=i+1:a
        %get the greatest coefficient of row
        greatest_coefficient=max(abs(U(j))); 
        greatest_coefficient=max(greatest_coefficient,abs(b(j)));
        
        %get the max scaled row
        if abs(U(j,i)/greatest_coefficient) > abs(U(i,i)/greatest_coefficient)
            index=j;
        end
    end
    if index ~= i
        line=sprintf('R%d <---> R%d',i,index);
        disp(line)
        %swap rows in U
        [U(i,1:a),U(index,1:a)]=deal(U(index,1:a),U(i,1:a));
        %swap rows in b
        [b(i),b(index)]=deal(b(index),b(i));
        % swap rows in L
        [L(i,1:i-1),L(index,1:i-1)]=deal(L(index,1:i-1),L(i,1:i-1));
        U
        L
        b
    end
    %elimination and calclate L
    for j =i+1:a
        factor =vpa(U(j,i)/U(i,i));
        if isnan(factor)
            continue;
        end
        line=sprintf('L%d%d = %0.5f',j,i,factor);
        disp(line)
        L(j,i)=vpa(factor)
        disp('eliminate in U')
        line=sprintf('R%d <-- R%d - %0.5f * R%d',j,j,factor,i);
        disp(line)
        for k =1:a
            U(j,k)=vpa(U(j,k)-factor*U(i,k));
        end
        U
    end
end
%Lz=b and using forward sub
z=zeros(a,1);
disp('Solving Lz=b using forward substitution')
z(1)=vpa(b(1)/L(1,1))
for i=2:a
    sum=0;
    for j=1:a
        if i~=j
            sum=vpa(sum+z(j)*L(i,j));
        end
    end
    z(i)=vpa((b(i)-sum)/L(i,i))
end
% Ux=z and using bacward sub
disp('Solving Ux=z using bacward substitution')
U
z
x=zeros(a,1);
x(a)=vpa(z(a)/U(a,a));
        if isinf(x(a))
        line=sprintf('x%d is free variable, let x%d=1',a,a);
        disp(line)
        x(a)=1;
        end
        x
for i= a-1:-1:1
    sum=0;
    for j=1:a
        if i~=j
            sum=vpa(sum+x(j)*U(i,j));
        end
        x(i)=vpa((z(i)-sum)/U(i,i));
    end
    if sum==0 && U(i,i)==0
        line=sprintf('x%d is free variable, let x%d=1',i,i);
        disp(line)
        x(i)=1;
        end
    x
    
end
diary off;
s=whos;
total= [s.bytes];
total_in_bytes=0;
for i=1 : size(total,2) 
    total_in_bytes=total_in_bytes+total(i);
end
total_in_bytes=total_in_bytes
output=fileread('files');
end