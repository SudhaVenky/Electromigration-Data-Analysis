function [sm] = slopeErr(x,y)
  n=length(x);
  mu_x=mean(x);
  mu_y=mean(y); 
  qx=sum((x-mu_x).^2); 
  qy=sum((y-mu_y).^2); 
  qxy=sum(x.*y)-sum(x)*sum(y)/n; 
  m=qxy/qx; 
  sm=sqrt((qy/qx-m^2)/(n-2)); 
  b=mu_y-m*mu_x; 
  sb=sqrt( (qy-qxy^2/qx)*(1/n+mu_x^2/qx)/(n-2) ); 
end   