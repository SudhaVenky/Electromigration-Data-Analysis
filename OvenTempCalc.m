function t_oven = OvenTempCalc(p,T,I)
  A = p(1,1)*I^2 + p(2,1)*I + p(3,1);
  B = p(4,1)*I^2 + p(5,1)*I + p(6,1);
  C = p(7,1)*I^2 + p(8,1)*I + p(9,1) - T;
  t_oven = roots([A,B,C]);
end 