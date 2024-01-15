function L=laplace(I,bw)
[m,n]=size(I);
L=zeros(m,n);
L=double(L);
I=double(I);
    for i=2:m-1
         for j=2:n-1
            if bw(i,j)
             Ixx=I(i+1,j)+I(i-1,j)-2*I(i,j); 
             Iyy=I(i,j+1)+I(i,j-1)-2*I(i,j);  
             L(i,j)=Ixx+Iyy;
            %L(i,j)=I(i+1,j)+I(i-1,j)+I(i,j+1)+I(i,j-1)-4*I(i,j);
            end
        end
    end
    imshow(L)
    