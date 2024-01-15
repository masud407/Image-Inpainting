function SNR=inpaint_PNSR(im,u)
im=double(im);
u=double(u);
[m,n]=size(im);
diff=(im-u).^2;
temp=sum(diff(:));
temp=temp/(n*m);
SNR=10*log10(255*255/temp);
end