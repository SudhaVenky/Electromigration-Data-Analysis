% filename: chara.m
% runs in GNU Octave 6.1.0
close all
x = [0.01 0.1:.2:5.2]'; % Current
y = [1 5:5:100];  % Temperature
P1 = 1.476E-4; P2 = -2.543E-4; P3 = 9.161E-5;  P4 = -6.871E-3; P5 = 1.989E-2; P6 = 0.992; 
P7 = 5.913; P8 = -4.103; P9 = 1.261;

AmbientTemp=y;
for j=2:length(x);AmbientTemp=[AmbientTemp;y];end
SpecTemp= P1*x.^2*y.^2+ P2*x.^1*y.^2+ P3*x.^0*y.^2+ P4*x.^2*y.^1+ P5*x.^1*y.^1+ P6*x.^0*y.^1+ P7*x.^2*y.^0+ P8*x.^1*y.^0+P9*x.^0*y.^0 ;

% DOE box

% determine current level based on %-fusion current, normalized to R0=15mOhm
R0=14.57; %must be in mOhm
i_high=(-.317*R0+10.47)*80/100;
i_low=(-.317*R0+10.47)*75/100;
trx=i_high; tlx=i_low; brx=i_high; blx=i_low; % top-left/right, bottom-left/right, of x
tr_y=65; tly=78; bry=52; bly=65; % ..., of y
xx=[trx tlx blx brx trx]; yy=[tr_y tly bly bry tr_y];

% plot everything

fs=25; % fontsize for graphs
lw=2; % linewidth for graphs

figure(1); %subplot(1,2,1)
pause(1);set(gcf,'Position',[ 55   55   1601   701])
z=SpecTemp'; maz=max(max(z)) ;
levels_=[0 1:floor(maz/10)]*10;levels=levels_(1:round(end/10):end);
[c,h]=contourf(x,y,z,levels,"linewidth", lw);
clabel (c, h,"LabelSpacing",444, "fontsize", round(.9*fs));
hold on; plot(xx,yy,'r',"linewidth", lw,xx,yy,'ro',"markersize",13)
ylabel('T_A [°C]');xlabel('I [A]')
title('T_S [°C]')
STint=interp2(y,x,SpecTemp,yy,xx);
for j=2:5;text(xx(j),yy(j),['  ' num2str(round(10*STint(j))/10)],"fontsize",fs*.9);end
set(gca, "linewidth", 1.5, "fontsize", fs)

figure (2)
%subplot(1,2,2)
z=(SpecTemp-AmbientTemp)'; maz=max(max(z)) ;
levels_=[0 1:floor(maz/10)]*10;levels=levels_(1:round(end/10):end);
[c,h]=contourf(x,y,z,levels,"linewidth", lw);
clabel (c, h,"LabelSpacing",444, "fontsize", round(.9*fs));
%colorbar(gca,"linewidth",lw,"fontsize",fs,"EastOutside")
hold on; plot(xx,yy,'r',"linewidth", lw,xx,yy,'ro',"markersize",13)
ylabel('T_A [°C]');xlabel('I [A]')
title('T_d_i_f_f (T_S - T_A) [K]')
STint=interp2(y,x,SpecTemp-AmbientTemp,yy,xx);
for j=2:5;text(xx(j),yy(j),['  ' num2str(round(10*STint(j))/10)],"fontsize",fs*.9);end
set(gca, "linewidth", 1.5, "fontsize", fs)

pause(1)
print -djpeg datfig.jpg
print -dpdfcrop datfig.pdf

##figure(1); %subplot(1,2,1)
##pause(1);set(gcf,'Position',[ 55   55   1601   701])
##z=SpecTemp; maz=max(max(z)) ;
##levels_=[0 1:floor(maz/10)]*10;levels=levels_(1:round(end/10):end);
##[c,h]=contourf(y,x,z,levels,"linewidth", lw);
##clabel (c, h,"LabelSpacing",444, "fontsize", round(.9*fs));
##%colorbar(gca,"linewidth",lw,"fontsize",fs,"EastOutside")
##hold on; plot(yy,xx,'r',"linewidth", lw,yy,xx,'ro',"markersize",13)
##xlabel('Ambient Temperature [°C]');ylabel('Current [A]')
##title('Specimen Temperature [°C]')
##%ST= P1*xx.^2.*yy.^2+ P2*xx.^1*yy.^2+ P3*xx.^0.*yy.^2+ P4*xx.^2.*yy.^1+ P5*xx.^1.*yy.^1+ P6*xx.^0.*yy.^1+ P7*xx.^2.*yy.^0+ P8*xx.^1.*yy.^0+P9*xx.^0.*yy.^0 ;
##STint=interp2(y,x,SpecTemp,yy,xx);
##for j=2:5;text(yy(j),xx(j),['  ' num2str(round(10*STint(j))/10)],"fontsize",fs*.9);end
##set(gca, "linewidth", 1.5, "fontsize", fs)

