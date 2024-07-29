function [P] = LoopPressure(ParentPipe,ParentP0, Q, D,k,L,gamma, niu)

%NL = length(Loops);
NP = length(D);
P=nan(size(Q));

Parents = unique(ParentPipe);
PSort = [ParentPipe',(1:NP)'];
Psort = sortrows(PSort,1);

for i = 1:NP
    ij = Psort(i,2);
    
        if ParentPipe(ij) == 0
            P0=ParentP0;
        else
            P0 = P(ParentPipe(ij));
        end
        A = (pi*D(ij)^2/4);
        Reynolds = abs(Q(ij))/A*D(ij)/niu;
        P(ij)= P0-sign(Q(ij))*gamma*Q(ij)^2*L(ij)/2/9.81/D(ij)/(A^2)*0.25/...
            ((log10(0.27*k(ij)/D(ij)+5.74*Reynolds^-0.9))^2);
    
end