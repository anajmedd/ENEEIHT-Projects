function [APPllr,VtoC, CtoV, iter]=myBPdecoder(Lch,CtoV,H,NbIter, InitFlag)
%========================================================================================%
% [APPllr,CtoV, iter]=myBPdecoder(Lch,CtoV,H,NbIter, InitFlag)
%
% Inputs:
% -------
%   -Lch: vector of LLRs from noisy observations
%   -CtoV: sparse matrix containing inital messages on Tanner graph
%   -H: H matrix for LDPC code
%   -Nbiter: number of internal iterations
%   -InitFlag: indicate if somme previous iterations have been performed.
%       By default set 0; Set to actual global iteration if used in concatenated scheme.
%
% Ouputs:
% -------
%   -APPllr: Vector containing APP llr for decisions
%   -CtoV  : The matrix of messages contained in the graph
%   -The number of iterations that have been performed
%========================================================================================%

%parameters
myfctBP = @(x) atanh(real(exp(x))); %handle BP function
LLRMAX=30;%Set up LLR Saturation
[M,N]=size(H);

numiter=0;
%init phase if first iteration is required. Must be handle differently to
%avoid all zeros sparse matrix.
if InitFlag==0 
VtoCsum=Lch.';
VtoC=double(H)*spdiags(VtoCsum.',0,N,N);
%tanh domain
VtoC = spfun(@tanh,VtoC/2);
%check pass
VtoClog= spfun(@log,VtoC);
tanhprod=sum(VtoClog,2).';
CtoV=spdiags(tanhprod.',0,M,M)*double(H);%only abs value are done up to now
CtoV=CtoV-VtoClog;
CtoV = 2*spfun(myfctBP,CtoV);
numiter=1;%, sum(paritychecks)
end

APPllr=sum(CtoV)+Lch.';
cw=(1-sign(APPllr))/2;
paritychecks = mod(H * cw', 2);

while (sum(paritychecks)~=0)  && (numiter<(NbIter))
%BP loop
%data pass
VtoCsum=sum(CtoV)+Lch.';
VtoC=double(H)*spdiags(VtoCsum.',0,N,N)-CtoV;

%tanh domain
VtoC = spfun(@tanh,VtoC/2);

%check pass
%gestion amplitude + signe en complexe
VtoClog= spfun(@log,VtoC);
tanhprod=sum(VtoClog,2);
CtoV=spdiags(tanhprod,0,M,M)*double(H);
CtoV=CtoV-VtoClog;
CtoV = 2*spfun(myfctBP,CtoV);

% Saturate CtoV for stability
index=find(abs(CtoV)> LLRMAX);
CtoV(index)=LLRMAX*sign(CtoV(index));

%decision and syndrome based stop criterion
APPllr=sum(CtoV)+Lch.';
cw=(1-sign(APPllr))/2;
paritychecks = mod(H* cw', 2);

numiter=numiter+1;
end
iter=numiter+InitFlag;
end