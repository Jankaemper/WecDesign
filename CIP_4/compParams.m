%CIP 4 Task c
set(0,'DefaultTextInterpreter', 'latex');

E=211000000000;
D=5;
l=100;
mTop=323000;
rho=7850;
t=1;
rrs=14.5/60;
f0=rrs*1.1;

func = @(t) sqrt(3*E*pi*D^3*t/(l^3*8*(mTop+0.25*rho*pi*D+t*l)))-f0*2*pi;
t = fsolve(func,t);

mTow= rho*pi*D*t*l;
towerCost = mTow/1000*500;

%plotting f_0 as function of t
figure;
hold on;
fplot( @(t) sqrt(3*E*pi*D^3*t/(l^3*8*(mTop+0.25*rho*pi*D+t*l)))/(2*pi), [0 0.5]);
plot(t,f0,'*');
xlabel('Wall thickness t [m]','FontSize',12);
ylabel('Eigenfrequency f0 [Hz]','FontSize',12);
title('Relationship: Eigenfrequency-Thickness', 'FontSize',14);
saveas(gcf,strcat('figures/eigenfrequency.jpg'));
hold off;

%campbell diagram
figure();
hold on;
fplot( @(x) f0, [0 0.4], 'Color','r','LineWidth',2);
fplot( @(x) 1*x, [0 0.4],'Color','b','Linestyle','--','LineWidth',2);
fplot( @(x) 3*x, [0 0.4],'Color','b','LineWidth',2);
fplot( @(x) 6*x, [0 0.4],'Color','b','LineWidth',2);
fplot( @(x) 9*x, [0 0.4],'Color','b','LineWidth',2);
fplot( @(x) 12*x, [0 0.4],'Color','b','LineWidth',2);
plot(f0, f0, 'ro', 'MarkerSize', 10);
plot(f0/3, f0, 'ro', 'MarkerSize', 10);
plot(f0/6, f0, 'ro', 'MarkerSize', 10);
plot(f0/9, f0, 'ro', 'MarkerSize', 10);
plot(f0/12, f0, 'ro', 'MarkerSize', 10);
ylim([0 1]);
legend('Tower bending','\Omega','3\Omega','6\Omega','9\Omega','12\Omega','location','Northeast');
xlabel('Rotor Speed [Hz]','FontSize',12);
ylabel('Eigenfrequency [Hz]','FontSize',12);
title('Campbell Diagram', 'FontSize',14);
%ax2 = axes('Position',[0 0.1 0.8 0.001],'Color','none')

saveas(gcf,strcat('figures/campbell.jpg'));
hold off;

