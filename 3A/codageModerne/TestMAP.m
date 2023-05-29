%MAP parity check : brute force
% decoder 
clear all 
N=4;
sig=2;
u=[de2bi((0:2^(N-1)-1)','left-msb')];
%G=[1 0 1;0 1 1];
G=[eye(N-1),ones(N-1,1)];
ctable=rem(u*G,2);
filterBank=1-2*ctable;

Ncwd=3;
Info=randi([0 1],Ncwd,N-1);
%Info=[0 1 0];
Cwds=rem(Info*G,2);
x=1-2*Cwds;
b=sig*randn(Ncwd,N);
y=x+b;
u_hat=zeros(Ncwd,N-1);
for n=1:Ncwd
    yrep=repmat(y(n,:),2^(N-1),1);
    d2=sum(abs(yrep-filterBank).^2,2);
    PYX=exp(-d2/2/sig^2);
    llr=log((1-ctable)'*PYX)-log((ctable)'*PYX);
end
