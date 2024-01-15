function It=inpaint(I,bw,L)
[m,n]=size(I);
It=zeros(m,n);
I=double(I);
    for i=2:m-1
         for j=2:n-1
            if bw(i,j)
           Ix=(I(i+1,j)-I(i-1,j))/2;
           Iy=(I(i,j+1)-I(i,j-1))/2;
           a=sqrt(Ix*Ix+Iy*Iy+1e-6);
           c=Ix/a;
           b=Iy/a;
           
          d=L(i+1,j)-L(i-1,j);
          e=L(i,j+1)-L(i,j-1);
          
          B=0.5*(d*(-b)+e*c);%Attention
          
          Ixb=I(i,j)-I(i-1,j); Ixf=I(i+1,j)-I(i,j);
          Iyb=I(i,j)-I(i,j-1); Iyf=I(i,j+1)-I(i,j);
          
          Ixbm=min(Ixb,0); IxbM=max(Ixb,0);
          Ixfm=min(Ixf,0); IxfM=max(Ixf,0);
          Iybm=min(Iyb,0); IybM=max(Iyb,0);
          Iyfm=min(Iyf,0); IyfM=max(Iyf,0);
        
         if B>0
           TDI=sqrt(Ixbm*Ixbm+IxfM*IxfM+Iybm*Iybm+IyfM*IyfM);
         else
           TDI=sqrt(IxbM*IxbM+Ixfm*Ixfm+IybM*IybM+Iyfm*Iyfm);
         end
         
          B=B*TDI;
          signB=sign(B);
          It(i,j)=signB*sqrt(sqrt(signB*B));      
          end
       end
    end
    