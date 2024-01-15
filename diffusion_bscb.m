function I=diffusion_bscb(I,bw)
[m,n]=size(I);
 M=2;
 I=double(I);
 for s=1:M 
  for i=2:m-1
    for j=2:n-1
           if bw(i,j)
               Ix=(I(i+1,j)-I(i-1,j))/2;
               Iy=(I(i,j+1)-I(i,j-1))/2;
               Ixx=I(i+1,j)+I(i-1,j)-2*I(i,j); 
               Iyy=I(i,j+1)+I(i,j-1)-2*I(i,j);
               Ixy=(I(i+1,j+1)+I(i-1,j-1)-I(i-1,j+1)-I(i+1,j-1))/4;
               p=Ix*Ix+Iy*Iy+1e-10; 
               q=0.2*(Iy*Iy*Ixx-2*Ix*Iy*Ixy+Ix*Ix*Iyy);
               k=q/p;
               I(i,j)=I(i,j)+k;
           end
          end
        end
     end
