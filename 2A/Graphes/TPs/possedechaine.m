function [ ok ] = possedechaine( G, chaine )
%POSSEDECHAINE G possede-t-il chaine ?
%   Detailed explanation goes here
ok = true;
paires = [chaine; circshift(chaine, 1, 2)]';
for iPaire = 1:size(paires, 1)
    ok = ok & isequal(G(paires(iPaire, :)), zeros(1, 2));
end;

end