function [Q,DeltaQ] = LoopMethod(Q, r, Loops,n)

NL = length(Loops);
DeltaQ = nan(NL,1);

for j=1:NL
    SigmaNum = 0;
    SigmaDenom = 0;
    for i = 1:Loops{j}.NP
        rij = r(Loops{j}.Pipes(i));
        Qij = Q(Loops{j}.Pipes(i))*Loops{j}.Directions(i);
        SigmaNum = SigmaNum+ rij*Qij*abs(Qij).^(n-1);
        SigmaDenom = SigmaDenom+ n*rij*abs(Qij).^(n-1);
    end
    DeltaQ(j)=-1*SigmaNum/SigmaDenom;
    Q(Loops{j}.Pipes(:))= Q(Loops{j}.Pipes(:))+DeltaQ(j).*Loops{j}.Directions(:);
end