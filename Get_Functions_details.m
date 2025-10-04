
% This function containts full information and implementations of the benchmark 
% functions in Table 1, Table 2, and Table 3 in the paper

% lb is the lower bound: lb=[lb_1,lb_2,...,lb_d]
% up is the uppper bound: ub=[ub_1,ub_2,...,ub_d]
% dim is the number of variables (dimension of the problem)

function [lb,ub,dim,fobj] = Get_Functions_details(F)


switch F
    case 'F1'
        fobj = @F1;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F2'
        fobj = @F2;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F3'
        fobj = @F3;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F4'
        fobj = @F4;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F5'
        fobj = @F5;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F6'
        fobj = @F6;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F7'
        fobj = @F7;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F8'
        fobj = @F8;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F9'
        fobj = @F9;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F10'
        fobj = @F10;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F11'
        fobj = @F11;
        lb=-800;
        ub=800;
        dim=100;
        
    case 'F12'
        fobj = @F12;
        lb=-800;
        ub=800;
        dim=100;
                
end

end

% F1

function o = F1(x)
o=sum(x.^2);
end

% F2

function o = F2(x)
o=sum(abs(x))+prod(abs(x));
end

% F3

function o = F3(x)
dim=size(x,2);
o=0;
for i=1:dim
    o=o+sum(x(1:i))^2;
end
end

% F4

function o = F4(x)
o=max(abs(x));
end

% F5

function o = F5(x)

dim=size(x,2);
o=0;
for i=1:dim
    o=o+i*abs(x(i));
end
end

% F6

function o = F6(x)
% o=sum(abs((x+.5)).^2);
dim=size(x,2);
o=0;
for i=1:dim
%     o=o+abs(x(i))^(i+1);
    o=o+i*abs(x(i))^4+rand;
end

end

% F7

function o = F7(x)
dim=size(x,2);
   o=sum([1:dim].*(x.^4));
end



% F8

function o = F8(x)
dim=size(x,2);
o=sum(x.^2-10*cos(2*pi.*x))+10*dim;
end

% F9

function o = F9(x)
dim=size(x,2);
o=-20*exp(-.2*sqrt(sum(x.^2)/dim))-exp(sum(cos(2*pi.*x))/dim)+20+exp(1);
end

% F10

function o = F10(x)
dim=size(x,2);
o=sum(x.^2)/4000-prod(cos(x./sqrt([1:dim])))+1;
end


% F11

function o = F11(x)

    dim=size(x,2);
    for i=1:dim
        o=abs(x(i)*sin(x(i))+0.1*x(i));
    end
end



% F12

function o = F12(x)
 dim=size(x,2);
     o=0;
     for i=1:dim
         o=o+abs(x(i)).*(sin(i.*x(i)^2./pi))^2;
     end
end
