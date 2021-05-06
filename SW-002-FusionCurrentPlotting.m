% In this document the initial resistance and fusion current data points are % manually entered into the arrays
%% ----------Fusion Current Char.----------------%
R0 = [17.12 14.21 14.78 16.59 18.16 20.38 15.89 12.95 12.61 10.79 11.16 12.93 13.95];
Ifuse = [5 6.1 5.8 5.1 4.8 4 5.5 6.25 6.4 7.2 6.9 6.25 6.1];
fusefit = polyfit(R0,Ifuse,1);
slope = fusefit(1);
int = fusefit(2);
figure (3);
set(gca, 'Fontsize', 22)
grid on
hold on
scatter (R0,Ifuse);
plot(R0, slope*R0 + int);
xlabel('R_0 @ 22C, 0.1A, [m?]','FontSize',22);
ylabel('Fusion Current [A]','FontSize',22);
legend({'Fuse Point','Fusion Fit'}, 'Location', 'NorthEast');
hold off
