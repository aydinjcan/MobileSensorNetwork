   function G=ousta_fod(gam,N,wb,wh)
   k=1:N; wu=sqrt(wh/wb);
   wkp=wb*wu.^((2*k-1-gam)/N); wk=wb*wu.^((2*k-1+gam)/N);
   G=zpk(-wkp,-wk,wh^gam); G=tf(G);
