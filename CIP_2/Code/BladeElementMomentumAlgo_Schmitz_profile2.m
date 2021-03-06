%inits

r = 5.058;
R = 62.18;
v1 = 10;
omega = 12.59/60*2*pi;
designTipSpeedRatio = 8.20;
N = 3;
count= 0;

resultChordLength = [];
resultAngles = [];
stationNumber = 0;
for r = [5.058	12.674	20.290	27.906	35.522	43.138	50.754	58.370	62.178]
    r
    %step 1
    a = 0;
    a_old = 1000;
    a_Dash = 0;
    while (count==0 || abs(a-a_old) > 0.0000000001)
        a_old = a;
        %step 2, step 3
        angleOfAttack = 10;
        %alpha = atan((v1*(1-a))/(omega*r*(1+a_Dash)))*180/pi
        alpha = atan(v1*(1-a)/(omega*r));
       % disp(alpha*180/pi);

        %step 4
        interpolationTable = xlsread('Interpol.xlsx','NACA 65-421','B6:D84');
        C_L = interp1(interpolationTable(:,1),interpolationTable(:,2),alpha*180/pi,'spline');
        C_D = interp1(interpolationTable(:,1),interpolationTable(:,3),alpha*180/pi,'spline');

        %step 5
        C_T = C_L * cos(alpha) + C_D *sin(alpha);
        C_Q = C_L * cos(alpha) - C_D *sin(alpha);

        %step 6
        c = 16*pi*r/(N*C_L)*(sin(1/3*alpha))^2;
        sigma = N*c/(2*pi*r);
        a_Dash_new = 1/((4*sin(alpha) * cos(alpha)/(sigma*C_Q)-1)) ;
        a = 1/(4*sin(alpha) * sin(alpha)/(sigma*C_T)+1);

        %step 7
        a_c = 0.2;
        K = 4*sin(alpha)^2/(sigma*C_T);
        a=0.5*(2+K*(1-2*a_c)-sqrt((K*(1-2*a_c)+2)^2+4*(K*a_c^2-1)));
        count = count+1;
    end;
    stationNumber = stationNumber +1;
    resultAngles(stationNumber) = alpha*180/pi-10;
    resultChordLength(stationNumber) = c;

end;

