%Cholesky decomposition for symmetric matrices
%cases?
%>> zero matrix?
%>>

function [L,U] = Cholesky(A,perc)
%set percision
digits(perc)
[r,c] = size(A);
A
%check if non-square of empty
if (r ~= c || r == 0 || c == 0)
    L = [];
    U = [];
    display('invalid input')
    return;
end

%check if non-symmetric
for i=1:1:r
    for j=1:1:c
        if( A(i,j)~=A(j,i) )
            L = [];
            U = [];
            display('matrix not symmetric')
            return;
        end
    end
end

%perform cholesky decomposition

L = zeros(r,c);
for i=1:1:r
    for j=1:1:i
        if( i == j ) %formula 1
            sum = 0;
            for k=1:1:i-1
                sum = vpa(sum + L(i,k)^2);
            end
            L(i,i) =vpa(sqrt( A(i,i) - sum ));
        else  %formula 2
            sum = 0;
            for k=1:1:j-1
                sum =vpa( sum + L(i,k)*L(j,k));
            end
            L(i,j) = vpa(( A(i,j) - sum ) / L(j,j));
        end
        if(isnan(L(i,j)))
            L = [];
            U = [];
            display('invalid matrix , L%d%d=0',j,j)
            return;
        end
    end
end

U = L';
return;

