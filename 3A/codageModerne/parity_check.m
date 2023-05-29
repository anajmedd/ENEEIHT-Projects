%ML parity check
% decoder
clear all;
N=4;
sig=0.00001;
u=[de2bi((0:2^(N-1)-1)','left-msb')]
%G=[1 0 1;0 1 1];
G=[eye(N-1),ones(N-1,1)]
ctable=rem(u*G,2);
FilterBank=1-2*ctable;

Ncwd=10000;
Info=randi([0 1],Ncwd,N-1);
Cwds=rem(Info*G,2);
x=1-2*Cwds;
b=sig*randn(Ncwd,N);
y=x+b;
u_hat=zeros(Ncwd,N-1);
for n=1:Ncwd
    ycorr=FilterBank*y(n,:).';
    [ymax,index]=max(ycorr);
    u_hat(n,:)=de2bi(index-1, N-1,'left-msb');
end