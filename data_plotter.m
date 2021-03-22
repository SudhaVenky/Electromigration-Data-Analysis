%  Data Plotter File  %
%  - Sudharsan Venkatesan, Michael Mayer  %

load '210118112131 Microconstriction - 4W - SnCu - Room Temp Aging - 2.mat'

TCR = 0.004183;
I_therm=[ 1.0 1.5 2.0 2.5 ];
I_age=[ 2.4 2.2 2.5 ];
I_age = 4.66;
T_room = 65;

%-----------------For 3 Samples------------------%
% w = [V(1,50) V(2,50) V(3,50);...
%      V(1,125) V(2,125) V(3,125);...
%      V(1,200) V(2,200) V(3,200)];
% R_0 = [V(1,10) V(2,10) V(3,10)] * 10000;
%-------------------------------------------------------%

%------------For One sample------------------%
w = [ V(3,1080) V(3,1240) V(3,1360) V(3,1400) ];
R_0 = V(3,20) * 10000;
%--------------------------------------------%

R=w./I_therm*1000;
P=w.*I_therm*1000;

figure (1)
plot(t/3600,V(3,:)*1000)
set(gca, "fontsize", 15)
xlabel('Time, h','FontSize',22);ylabel('Voltage, mV','FontSize',22);

figure (2)
plot (1:length(t), V(3,:)*1000)
set(gca, "fontsize", 15)
xlabel('Count');ylabel('Voltage, V');

figure (3)
plot(P,R)
set(gca, "fontsize", 15)
xlabel('Power, mW','FontSize',22);ylabel('Resistance, mOhm','FontSize',22);hold on

%%

%--------------------------For one sample--------------%
coeff = polyfit(P,R,1);
Rth = 1000*coeff(1)/TCR/R_0;
c_start = 1973;
c_end = 12191;
v1_aging = V(3,c_start:c_end);
r1_aging = v1_aging*1000./I_age;
p1_aging = v1_aging*1000.*I_age;
t1_aging = p1_aging*Rth/1000;

figure (4)
plot(t(1,c_start:c_end)/3600,p1_aging)
set(gca, "fontsize", 15)
xlabel('Time, h','FontSize',22);ylabel('Power, mW','FontSize',22);

figure (5)
plot(t(1,c_start:c_end)/3600,t1_aging)
set(gca, "fontsize", 15)
xlabel('Time, h','FontSize',22);ylabel('Joule Heating, C','FontSize',22);

figure (6)
plot(t(1,c_start:c_end)/3600,t1_aging+T_room)
set(gca, "fontsize", 15)
xlabel('Time, h','FontSize',22);ylabel('Specimen temp, C','FontSize',22);

figure (7)
plot(t(1,c_start:c_end)/3600,r1_aging)
set(gca, "fontsize", 15)
xlabel('Time, h','FontSize',22);ylabel('Resistance, mOhm','FontSize',22);

coeff2 = polyfit(t(1,c_start:c_end),r1_aging,1);

fprintf('R_0.1A: %d\n', R_0)
fprintf('R_start: %d\n', r1_aging(1))
fprintf('R_end: %d\n', r1_aging(end))
fprintf('T_start: %d\n', t1_aging(1)+T_room)
fprintf('T_end: %d\n', t1_aging(end)+T_room)
fprintf('P_start: %d\n', p1_aging(1))
fprintf('P_end: %d\n', p1_aging(end))
fprintf('TTF: %d\n', t(length(r1_aging)+c_start)/3600)
fprintf('Rth: %d\n', Rth)
fprintf('Rate: %d\n', coeff2(1))

%%
%-----------------For 3 Samples----------------%

% coeff1 = polyfit(P(:,1),R(:,1),1);
% coeff2 = polyfit(P(:,2),R(:,2),1);
% coeff3 = polyfit(P(:,3),R(:,3),1);
% coeff_mat = [coeff1;coeff2;coeff3];
% Rth = [1000*coeff_mat(1,1)/TCR/R_0(1) 1000*coeff_mat(2,1)/TCR/R_0(2) 1000*coeff_mat(3,1)/TCR/R_0(3)];
% 
% c_start = 600
% c_end1 = 146400
% v1_aging = V(1,c_start:c_end);
% r1_aging = v1_aging*1000/2.4;
% p1_aging = v1_aging*1000*2.4;
% t1_aging = p1_aging*Rth(1)/1000;
% 
% 
% c_end2 = 26500
% v2_aging = V(2,c_start:c_end);
% r2_aging = v2_aging*1000/2.2;
% p2_aging = v2_aging*1000*2.2;
% t2_aging = p2_aging*Rth(2)/1000;
% 
% 
% c_end3 = 146400
% v3_aging = V(3,c_start:c_end);
% r3_aging = v3_aging*1000/2.5;
% p3_aging = v3_aging*1000*2.5;
% t3_aging = p3_aging*Rth(3)/1000;
% 
% figure 4
% plot(t(1,c_start:26500)/3600,r2_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Resistance, mOhm','FontSize',22);
% 
% figure 5
% plot(t(1,c_start:26500)/3600,p2_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Power, mW','FontSize',22);
% 
% figure 6
% plot(t(1,c_start:26500)/3600,t2_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Joule Heating, C','FontSize',22);
% 
% figure 7
% plot(t(1,c_start:26500)/3600,t2_aging+T_room)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Specimen temp, C','FontSize',22);
% 
% %___
% 
% figure 8
% plot(t(1,c_start:c_end)/3600,p1_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Power, mW','FontSize',22);
% 
% figure 9
% plot(t(1,c_start:c_end)/3600,t1_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Joule Heating, C','FontSize',22);
% 
% figure 10
% plot(t(1,c_start:c_end)/3600,t1_aging+T_room)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Specimen temp, C','FontSize',22);
% 
% figure 11
% plot(t(1,c_start:c_end)/3600,r1_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Resistance, mOhm','FontSize',22);
% 
% 
% %____
% 
% figure 12
% plot(t(1,c_start:c_end)/3600,p3_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Power, mW','FontSize',22);
% 
% figure 13
% plot(t(1,c_start:c_end)/3600,t3_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Joule Heating, C','FontSize',22);
% 
% figure 14
% plot(t(1,c_start:c_end)/3600,t3_aging+T_room)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Specimen temp, C','FontSize',22);
% 
% figure 15
% plot(t(1,c_start:c_end)/3600,r3_aging)
% set(gca, "fontsize", 15)
% xlabel('Time, h','FontSize',22);ylabel('Resistance, mOhm','FontSize',22);

%%
%------------------Finding end condition----------------%

RPR = zeros(1,4);

for n = 1000: 500: c_end
  R1 = r1_aging(n-500);
  R2 = r1_aging(n);
  pR = (R2 - R1)/R1 *100;
  RPR = [RPR;n R1 R2 pR];
end
disp(RPR)

%------------------------Displaying Final Data----------------%

fprintf('R_0.1A: %d\n', R_0)
fprintf('R_start: %d\n', r1_aging(5))
fprintf('R_end: %d\n', r1_aging(end))
fprintf('T_start: %d\n', t1_aging(5))
fprintf('T_end: %d\n', t1_aging(end))
fprintf('P_start: %d\n', p1_aging(5))
fprintf('P_end: %d\n', p1_aging(end))
fprintf('TTF: %d\n', t(length(r1_aging)+c_start)/3600)
fprintf('Rth: %d\n', Rth)



%--------------------Appendix----------------------%

% w2=[V(2,50) V(2,125) V(2,200)]
% I_therm=[0.5 1 1.5];
% R2=w2./I_therm*1000;
% P2=w2.*I_therm*1000;
% coefficients = polyfit(P2,R2,1);
% slope = coefficients(1)
% intercept = coefficients(2)