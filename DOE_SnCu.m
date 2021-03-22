format long g

load '210118152717 Microconstriction - 4W - SnCu - Temp+Pow Char.mat'

figure (7)
plot(t/3600,V)
set(gca, "fontsize", 25)
xlabel('Time, h','FontSize',25); ylabel('Voltage, V','FontSize',25);
r00 = V(1,10)*1000/0.1

%-------------------------------SnCu-----------------------------------------
%------Sample 1------
V_25 = [ 0.0014549   0.0073137   0.0148054   0.0228348   0.0312786   0.0404899   0.0512365   0.0638992 ];         
V_45 = [ 0.0015775   0.0079450   0.0161241   0.0247558   0.0339114   0.0439870   0.0556152   0.0701271 ];         
V_65 = [ 0.0017160   0.0086143   0.0174690   0.0269392   0.0369307   0.0480336   0.0605540   0.0752175 ];         
V_85 = [ 0.0018075   0.0090981   0.0185511   0.0285228   0.0394006   0.0517772   0.0651807   0.0815565 ];
V_100 = [0.0019195   0.0096469   0.0195912   0.0302165   0.0414842   0.0538457   0.0681387   0.0866470 ];


%------Sample 2------
% V_25 = [ 0.0012857   0.0064819   0.0130837   0.0198504   0.0269895   0.0345459   0.0429820   0.0521857 ];        
% V_45 = [ 0.0013889   0.0070515   0.0142791   0.0216720   0.0294940   0.0377418   0.0471627   0.0569798 ];         
% V_65 = [ 0.0014942   0.0075385   0.0152390   0.0232364   0.0316683   0.0407058   0.0504903   0.0606230 ];         
% V_85 = [ 0.0015298   0.0077351   0.0158341   0.0242772   0.0331206   0.0425225   0.0523821   0.0635134 ];
% V_100 = [0.0016160   0.0081585   0.0165091   0.0250710   0.0341105   0.0437175   0.0543966   0.0663214 ];

%-----Sample 3-------
% V_25 = [ 0.0014168   0.0074601   0.0151398   0.0231025   0.0315058   0.0404922   0.0505369   0.0617709 ];       
% V_45 = [ 0.0015361   0.0081000   0.0165074   0.0251798   0.0343698   0.0442038   0.0549286   0.0666349 ];        
% V_65 = [ 0.0016487   0.0086427   0.0175534   0.0268578   0.0366305   0.0471742   0.0582461   0.0699127 ];    
% V_85 = [ 0.0016689   0.0087389   0.0179237   0.0275897   0.0375842   0.0482247   0.0591580   0.0710596 ];
% V_100 = [0.0017194   0.0090257   0.0183309   0.0280101   0.0381846   0.0490655   0.0608794   0.0742893 ];

%---------------SnCu--------------------
I = [0.1 0.5 1.0 1.5 2.0 2.5 3.0 3.5 ];

T = [25 45 65 85 100];
V = [V_25;V_45;V_65;V_85;V_100;];
I_vec = [I;I;I;I;I;];
R = V ./I *1000;

R_25 = V_25./I*1000;
R_45 = V_45./I*1000;
R_65 = V_65./I*1000;
R_85 = V_85./I*1000;
R_100 = V_100./I*1000;

%TCR calc.:
[p1, s1, u1] = polyfit(I,R_25,2);
[R_25_0 , R_25Del] = polyval(p1,0,s1,u1); 

[p2, s2, u2] = polyfit(I,R_45,2);
[R_45_0 , R_45Del] = polyval(p2,0,s2,u2); 

[p3, s3, u3] = polyfit(I,R_65,2);
[R_65_0 , R_65Del] = polyval(p3,0,s3,u3); 

[p4, s4, u4] = polyfit(I,R_85,2);
[R_85_0 , R_85Del] = polyval(p4,0,s4,u4); 

[p5, s5, u5] = polyfit(I,R_100,2);
[R_100_0 , R_100Del] = polyval(p5,0,s5,u5); 

R = [R_25_0 R_45_0 R_65_0 R_85_0 R_100_0];
TR_fit = polyfit(T,R,1);
TCR_0 = TR_fit(1)/TR_fit(2);
TCR = 1/(25+(1/TCR_0))

figure (1)
plot(T,R, 'o-')
hold on
plot(T, TR_fit(1)*T + TR_fit(2),'--');
hold off
% title('Temperature vs Resistance R0','FontSize',22)
set(gca, "fontsize", 22)
xlabel('Temperature, ℃','FontSize',22);ylabel('Resistance, mΩ','FontSize',22);

% Power Calc:
P_25 = V_25.*I*1000;
P_45 = V_45.*I*1000;
P_65 = V_65.*I*1000;
P_85 = V_85.*I*1000;
P_100 = V_100.*I*1000;

coeff1 = polyfit(P_25,R_25,1);
Rth1 = 1000*coeff1(1)/TCR/R_25(1,1)
Rth1_err = slopeErr(P_25,R_25)

coeff2 = polyfit(P_45,R_45,1);
Rth2 = 1000*coeff2(1)/TCR/R_45(1,1)
Rth2_err = slopeErr(P_45,R_45)

coeff3 = polyfit(P_65,R_65,1);
Rth3 = 1000*coeff3(1)/TCR/R_65(1,1)
Rth3_err = slopeErr(P_65,R_65)

coeff4 = polyfit(P_85,R_85,1);
Rth4 = 1000*coeff4(1)/TCR/R_85(1,1)
Rth4_err = slopeErr(P_85,R_85)

coeff5 = polyfit(P_100,R_100,1);
Rth5 = 1000*coeff5(1)/TCR/R_100(1,1)
Rth5_err = slopeErr(P_100,R_100)

Rth = [Rth1 Rth2 Rth3 Rth4 Rth5]
Rth_err = [Rth1_err Rth2_err Rth3_err Rth4_err Rth5_err]

T_25 = P_25*Rth1/1000 + 25;
T_45 = P_45*Rth2/1000 + 45;
T_65 = P_65*Rth3/1000 + 65;
T_85 = P_85*Rth4/1000 + 85;
T_100 = P_100*Rth5/1000 + 100;

T_spec = [T_25;T_45;T_65;T_85;T_100;]

figure (2)
hold on
plot(I,T_25, 'o-')
plot(I,T_45, 'o-')
plot(I,T_65, 'o-')
plot(I,T_85, 'o-')
plot(I,T_100, 'o-')
% title('Specimen Temperature profile with reused sample','FontSize',22)
set(gca, "fontsize", 22)
xlabel('Current, A','FontSize',22);ylabel('Temperature, ℃','FontSize',22);

figure (3)
hold on
plot(P_25,R_25, 'o-')
plot(P_45,R_45, 'o-')
plot(P_65,R_65, 'o-')
plot(P_85,R_85, 'o-')
plot(P_100,R_100, 'o-')
set(gca, "fontsize", 25)
% title('R-P Char. profile stressed to 3.5A','FontSize',22)
xlabel('Power, W','FontSize',25);ylabel('Resistance, mΩ','FontSize',25);
hold off

figure (4)
hold on
plot(I,R_25, 'o-')
plot(I,R_45, 'o-')
plot(I,R_65, 'o-')
plot(I,R_85, 'o-')
plot(I,R_100, 'o-')
% title('R vs I profile with reused sample','FontSize',22)
set(gca, "fontsize", 25)
xlabel('Current, A','FontSize',25);ylabel('Resistance, mΩ','FontSize',25);

figure (5)
errorbar(T,Rth,Rth_err)
% title('Rth vs Temp with Error','FontSize',22)
set(gca, "fontsize", 25)
xlabel('Temperature, ℃','FontSize',25);ylabel('Rth, mΩ/℃','FontSize',25);

figure (6)
surf(I,T,T_spec)
ylabel('T_O_v_e_n, ℃','FontSize',18);
xlabel('I_S_t_r_e_s_s, A','FontSize',18);
zlabel('T_S_p_e_c, ℃','FontSize',18);

T_oven = [ 25  25  25  25  25  25  25  25 ... 
           45  45  45  45  45  45  45  45 ...
           65  65  65  65  65  65  65  65 ...
           85  85  85  85  85  85  85  85 ...
           100 100 100 100 100 100 100 100];
I_samp = [I I I I I];
T_samp = [T_25 T_45 T_65 T_85 T_100];

PFit = polyFit2D(T_samp,I_samp,T_oven,2,2);
Fval = polyVal2D(PFit,2,85,2,2)

%-----Error Calc------------%
[row,col] = size(T_spec);
T_calc = zeros(row,col);
I_mat =  [I;I;I;I;I];
T_mat =  [ 25  25  25  25  25  25  25  25; ... 
           45  45  45  45  45  45  45  45; ...
           65  65  65  65  65  65  65  65; ...
           85  85  85  85  85  85  85  85; ...
           100 100 100 100 100 100 100 100 ];
for n = 1:row
    for m = 1:col
        T_calc (n,m) = polyVal2D(PFit,I_mat(n,m),T_mat(n,m),2,2);
    end
end

T_err = T_calc - T_spec;
func_err = mean(mean(abs(T_err)))
