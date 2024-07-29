%problem setup
n=2;
tolerance = 0.000001;
MaxIter = 10000;
RougnessCoeff = 0.00026;
Diameter = 0.3;
GammaCoef = 9800;
niu = (1*10^-6);

L=[100;100;150;150;150;100;100;150;150;150;100;100];
Q0 = [0.02;-0.03;0.03;0.05;0.03;0.01;-0.04;0.02;0.03;-0.01;-0.08;-0.05];
ParentPipe  =[4,4,6,0,7,0,0,6,0,7,9,9];
ParentP0 = 500000;

NLoops=4;
Loops = cell(NLoops,1);

Loops{1}.NP=4;
Loops{1}.Pipes=[3;6;4;1];
Loops{1}.Directions=[1;1;-1;-1];

Loops{2}.NP=4;
Loops{2}.Pipes=[4;7;5;2];
Loops{2}.Directions=[1;1;-1;-1];

Loops{3}.NP=4;
Loops{3}.Pipes=[8;11;9;6];
Loops{3}.Directions=[1;1;-1;-1];

Loops{4}.NP=4;
Loops{4}.Pipes=[9;12;10;7];
Loops{4}.Directions=[1;1;-1;-1];

D = ones(12,1)*Diameter;
k=ones(12,1)*RougnessCoeff;

f=find_F_Turbulent(k,D);
r=find_r(D,L,f);

%Solver
disp(Q0)
[Q, DeltaQ] = LoopMethod(Q0,r,Loops,n); %Initial call - use Q0
    Ni = 1;
    disp(['iteration = ', num2str(Ni)])
    disp(Q)
while max(abs(DeltaQ))/mean(abs(Q))>tolerance || Ni>MaxIter
    
        [Q, DeltaQ] = LoopMethod(Q,r,Loops,n); %iterations - use Q that keeps updating every interation
         Ni=Ni+1;
         disp(['iteration = ', num2str(Ni)])
        disp(Q)
        disp( DeltaQ)
       
end
[P] = LoopPressure(ParentPipe,ParentP0, Q, D,k,L,GammaCoef, niu);
disp('Result Q=')
disp(Q) %show the final values of Q
disp('Result P=')
disp(P) %show the final values of P