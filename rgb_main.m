%function rgb_main 
clear all;
clc;
tic

[filename, pathname] = uigetfile('cd/*.*','Open the defect image document');
if filename==0
    msgbox('You did not select the document correctly!');
end
imfile = strcat(pathname,filename);
u=imread(imfile);

[filename, pathname] = uigetfile('cd/*.*','Open the defect mask document');
if filename==0
    msgbox('You did not select the document correctly!');
end
imfile = strcat(pathname,filename);
mask=imread(imfile);

u=double(u);
mask=double(mask);
mask=logical(mask);
mask_C=cat(3,mask,mask,mask);
[m,n,v]=size(u);
S=3.*sum(mask(:));
%u=imread('S_L_o.bmp');
%bw=imread('S_L_m.bmp');

% %Dilation
 %se=[1;1;1];%Levek
 
 %bw=imdilate(mask,se);
 %bw=imdilate(bw,se);
% se=[1,1,1];
% bw=imdilate(bw,se);
% bw=imdilate(bw,se);
% bw=imdilate(bw,se);
% bw=imdilate(bw,se);
% imshow(u);pixval;
% bw=zeros(m,n);         %Read position
% bw(799:2489,857:859)=1;
% bw=logical(bw);
%%%%%%%Draw the inpainting area manually
% bw=roipoly(u);        %Interactive drawing
% imshow(bw);
% imwrite(bw,'f:\matlab6p5\work\picture\bw.bmp');
% bw=imread('F:\MATLAB6p5\work\picture\bw.bmp');
dt=0.1;
It=zeros(m,n);
plus=zeros(m,n);
L=zeros(m,n);
k=zeros(m,n);
%T=2;M=2
T=5000;M=2;
I=zeros(m,n);
f=zeros(m,n);
f=imnoise(f,'gaussian',0.9,1);
f=cat(3,f,f,f);
u=u.*(~mask_C)+255.*f.*(mask_C);
Iro=u(:,:,1);
Igo=u(:,:,2);
Ibo=u(:,:,3);
th=zeros(1,T);
%figure(1);imshow(uint8(u));
% imwrite(first,'E:\TestImages\roadlightComparisonInDifferentMethods\first.bmp');
 plus=double(plus);
 It=double(It);
 % h = waitbar(0,'Please wait...');
 for t=1:T
  %tbar(t/T,h)    

  if mod(t,15)~=0    
    I1=Iro;  
    L=laplace(I1,mask);
    It=inpaint(I1,mask,L);
    plus=dt*It;
    Iro=I1+plus;
   else
       I1=Iro;
       Iro=diffusion_bscb(I1,mask);
   end
    
  if mod(t,15)~=0   
    I2=Igo;  
    L=laplace(I2,mask);
    It=inpaint(I2,mask,L);
    plus=dt*It;
    Igo=I2+plus;
   else
       I2=Igo; 
       Igo=diffusion_bscb(I2,mask);
   end
   
  
  if mod(t,15)~=0 
    I3=Ibo;
    L=laplace(I3,mask);
    It=inpaint(I3,mask,L);
    plus=dt*It;
    Ibo=I3+plus;
   else
       I3=Ibo;
       Ibo=diffusion_bscb(I3,mask);
   end
   phio=cat(3,I1,I2,I3);
   phi=cat(3,Iro,Igo,Ibo);
   ph=abs(phio-phi);
    th(t)=sum(ph(:))./S;
   if th(t)<=0.1
       break;
   end
   if mod(t,20)==0
    figure(2)
    imshow(uint8(phi));
   end
end  
%close(h)
figure(2);
imshow(uint8(phi));
toc