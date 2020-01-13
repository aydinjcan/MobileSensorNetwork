function FraOrder = CalFracPra( FraAlpha,n)
%CALFRACPRA Summary of this function goes here
%   Detailed explanation goes here
% FraAlpha=-0.5;n=4;
FraOrder.sysm=ousta_fod(FraAlpha,n,1e-3,1e3);
[FraOrder.a,FraOrder.b]=tfdata(FraOrder.sysm,'v');
for i=1:n+1;
    if i==1
FraOrder.h=FraOrder.b(n+2-i);
    else 
     FraOrder.h(i)=FraOrder.b(n+2-i)-FraOrder.a(n-(i-2):n)* FraOrder.h'; 
    end
end
% FracOrder.h1=FracOrder.b(n)-FracOrder.a(n)*FracOrder.h0;
% FracOrder.h2=FracOrder.b(n-1)-FracOrder.a(n)*FracOrder.h1-FracOrder.a(n-1)*FracOrder.h0;
% FracOrder.h3=FracOrder.b(n-2)-FracOrder.a(n)*FracOrder.h2-FracOrder.a(n-1)*FracOrder.h1-FracOrder.a(n-2)*FracOrder.h0;
% FracOrder.h4=FracOrder.b(n-3)-FracOrder.a(n)*FracOrder.h3-FracOrder.a(n-1)*FracOrder.h2-FracOrder.a(n-2)*FracOrder.h1-FracOrder.a(n-2)*FracOrder.h0;

global FraOrder

