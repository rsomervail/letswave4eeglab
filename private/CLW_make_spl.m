function header=CLW_make_spl(header)
if sum([header.chanlocs.topo_enabled])==0
    return;
end
load('headmodel.mat');
HeadCenter = [0,0,30];
ElectDFac  = 1.06;
transmat   = [0 -10 0 -0.1000 0 -1.600 1100 1100 1100]; % arno

eloc_file=header.chanlocs;
indices = find(~cellfun('isempty', { eloc_file.X }) & [header.chanlocs.topo_enabled]==1);
Xeori = [ eloc_file(indices).X ]';
Yeori = [ eloc_file(indices).Y ]';
Zeori = [ eloc_file(indices).Z ]';
newcoords = [ Xeori Yeori Zeori ];
newcoords = traditionaldipfit(transmat)*[ newcoords ones(size(newcoords,1),1)]';
newcoords = newcoords(1:3,:)';
newcoordsnorm      = newcoords - ones(size(newcoords,1),1)*HeadCenter;
tmpnorm            = sqrt(sum(newcoordsnorm.^2,2));
Xe = newcoordsnorm(:,1)./tmpnorm;
Ye = newcoordsnorm(:,2)./tmpnorm;
Ze = newcoordsnorm(:,3)./tmpnorm;

enum = length(Xe);
onemat = ones(enum,1);
G = zeros(enum,enum);
for i = 1:enum
    ei = onemat-sqrt((Xe(i)*onemat-Xe).^2 + (Ye(i)*onemat-Ye).^2 + ...
        (Ze(i)*onemat-Ze).^2); % default was /2 and no sqrt
    G(i,:)=calcgx(ei);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Project head vertices onto unit sphere
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spherePOS      = POS-ones(size(POS,1),1)*HeadCenter; % recenter
nPOSnorm       = sqrt(sum(spherePOS.^2,2));
spherePOS(:,1) = spherePOS(:,1)./nPOSnorm;
spherePOS(:,2) = spherePOS(:,2)./nPOSnorm;
spherePOS(:,3) = spherePOS(:,3)./nPOSnorm;
x = spherePOS(:,1);
y = spherePOS(:,2);
z = spherePOS(:,3);


[~,I]=sort(get_dist([Xe Ye Ze],spherePOS'),2);
center=[0,0,-100];
for k=1:enum
    M=mean(POS(I(k,1:20),:))-center;
    newElect(k,:)=mean(POS(I(k,1:20),:))+M./norm(M)*5;
end

gx = fastcalcgx(x,y,z,Xe,Ye,Ze);
header.spl.GG=gx*pinv([(G + 0.1);ones(1,length(indices))]);
header.spl.indices=indices;
header.spl.newElect=newElect;
end

function z = get_dist(w,p)
S = size(w,1);
Q = size(p,2);
z = zeros(S,Q);
if (Q<S)
    p = p';
    copies = zeros(1,S);
    for q=1:Q
        z(:,q) = sum((w-p(q+copies,:)).^2,2);
    end
else
    w = w';
    copies = zeros(1,Q);
    for i=1:S
        z(i,:) = sum((w(:,i+copies)-p).^2,1);
    end
end
z = sqrt(z);
end

function [out] = calcgx(in)
out = zeros(size(in));
m = 4;       % 4th degree Legendre polynomial
for n = 1:7  % compute 7 terms
    out = out + ((2*n+1)/(n^m*(n+1)^m))*my_legendre(n,in);
end
out = out/(4*pi);
end


%%%%%%%%%%%%%%%%%%%
function gx = fastcalcgx(x,y,z,Xe,Ye,Ze)
onemat = ones(length(x),length(Xe));
EI = onemat - sqrt((repmat(x,1,length(Xe)) - repmat(Xe',length(x),1)).^2 +...
    (repmat(y,1,length(Xe)) - repmat(Ye',length(x),1)).^2 +...
    (repmat(z,1,length(Xe)) - repmat(Ze',length(x),1)).^2);
%
gx = zeros(length(x),length(Xe));
m = 4;
for n = 1:7
    gx = gx + ((2*n+1)/(n^m*(n+1)^m))*my_legendre(n,EI);
end
gx = gx/(4*pi);
end

function y=my_legendre(n,x)
switch n
    case 0
        p=1;
    case 1
        p=[1,0];
    case 2
        p=[3 0 -1]/2;
    case 3
        p=[5 0 -3 0]/2;
    case 4
        p=[35 0 -30 0 3]/8;
    case 5
        p=[63 0 -70 0 15 0]/8;
    case 6
        p=[231 0 -315 0 105 0 -5]/16;
    case 7
        p=[429 0 -693 0 315 0 -35 0]/16;
    case 8
        p=[6435 0 -12012 0 6930 0 -1260 0 35]/128;
    case 9
        p=[12155 0 -25740 0 18018 0 -4620 0 315 0]/128;
    case 10
        p=[46189 0 -109395 0 90090 0 -30030 0 3465 0 -63]/256;
end
y=polyval(p,x);
end

