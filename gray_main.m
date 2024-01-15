clear all;
close all;
%% Open the image file
[filename, pathname] = uigetfile('cd/*.*','Open the defect image document');
if filename==0
    msgbox('You did not select the document correctly!');
end
imfile = strcat(pathname,filename);
u=imread(imfile);
%% open the mask
[filename, pathname] = uigetfile('cd/*.*','Open the defect mask document');
if filename==0
    msgbox('You did not select the document correctly!');
end
imfile = strcat(pathname,filename);
bw=imread(imfile);
if size(bw,3)==3
    bw = rgb2gray(bw);
end
%% preprocessing the mask
if size(u,3)==1%Deal with gray-level image
    u=double(u(:,:,1));
    figure(1);imshow(u,[]);colormap gray
    %im=imread('cv.jpg');
    %im=im(:,:,1);
    mask=double(bw);
    mask=logical(mask);
    figure(2);imshow(mask,[]);colormap gray
    [m,n]=size(u);
    se=[1;1;1];%Level
    bw=imdilate(bw,se);
%% Process the greyscale image with the mask
    dt=0.1;
    %It=zeros(m,n);
    plus=zeros(m,n);
    %L=zeros(m,n);
    k=zeros(m,n);
    T=10000;M=2;
    I=zeros(m,n);
    f=zeros(m,n);
    f=imnoise(f,'gaussian',0.9,1);
    u=u.*(~mask)+255.*f.*mask;
    figure(3)
    imshow(uint8(u))
    h = waitbar(0,'Please wait...');
    %% Inpainting of the greyscale image
    tic
     for t=1:T
      waitbar(t/T,h)    
     if mod(t,15)~=0      
        L=laplace(u,mask);
        It=inpaint(u,mask,L);
        plus=dt*It;
        u=u+plus;
     else       
         u=diffusion_bscb(u,bw);
      end
      if mod(t,20)==0
          imshow(uint8(u))
      end
     end
     %PNR=inpaint_PNSR(im,u);
     toc;
     disp('The PNSR of repaired is:');
    disp(PNR);
    % imwrite(uint8(u),'cv_BSCB.png');
end %
%% Processing RGB image with masks
if size(u,3)==3%Deal with RGB image
    u=double(u);
%     [m,n]=size(u);
    mask=double(bw);
    mask=logical(mask);
%     mask=imresize(mask,[306 200]);
    mask_C=cat(3,mask,mask,mask);
    [m,n,v]=size(u);
    S=3.*sum(mask(:));
   
    dt=0.1;
    It=zeros(m,n);
    plus=zeros(m,n);
    L=zeros(m,n);
    k=zeros(m,n);
    %T=2;M=2
    T=8000;M=2;
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
%%Impaint the RGB image using PDE
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
    %toc
end

