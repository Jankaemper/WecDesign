%inits
c_l_design = 1.345
density = 1.225
r = 5.058;
R = 62.18;
v1 = 10;
omega = 12.59/60*2*pi;
designTipSpeedRatio = 8.20;
N = 3;
a_c = 0.2;
count= 0;
stationNumber = 0;

for r = [1.250	5.058	12.674	20.290	27.906	35.522	43.138	50.754	58.370	62.178]
    %step 1
    r
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
        interpolationTable = xlsread('Interpol.xlsx','NACA 65-415','B6:D81');
        C_L = interp1(interpolationTable(:,1),interpolationTable(:,2),alpha*180/pi,'spline');
        C_D = interp1(interpolationTable(:,1),interpolationTable(:,3),alpha*180/pi,'spline');

        %step 5
        C_Thrust = C_L * cos(alpha) + C_D *sin(alpha);
        C_Torque = C_L * cos(alpha) - C_D *sin(alpha);

        %prandtl correction
        
        %step 6
        c = 2*pi*R/N*8/(9*C_L)/(designTipSpeedRatio*sqrt((designTipSpeedRatio*r/R)^2+4/9));
        sigma = N*c/(2*pi*r);
        a_Dash = 1/((4*sin(alpha) * cos(alpha)/(sigma*C_Torque)-1)) ;
        a = 1/(4*sin(alpha) * sin(alpha)/(sigma*C_Thrust)+1);
        
        count = count+1;
    end;
   
    % Step 8
    stationNumber = stationNumber +1;
    
    % Power calculation
    dQ(stationNumber) = 0.5*density*N*(v1*(1-a))*omega*r*(1+a_Dash)*c*C_Torque/(sin(alpha)*cos(alpha))
    dT(stationNumber) = 0.5*density*N*v1^2*(1-a)^2*c*C_Thrust/(sin(alpha))^2;
    dL(stationNumber) = 0.5*density*sqrt(v1.^2+(omega*r)^2)*C_L;
    dP(stationNumber) = N * dL(stationNumber) * sin(alpha) *omega *r
    
    % Step 9; Corrections
    
    % Prandtl correction:
    % section 2.1 two different rated wind speeds necessary
    f_tip=2/pi *acos(exp(-N/2*(1-r/R) / (r/R*sin(alpha))));
    
    % Section 2.2
    f_cl_snel(stationNumber) = 3*(c/r)^2
    f_cl_chhansen(stationNumber) = 2.2*(c/r)*(cosd(alpha*180/pi-10))^4
    
    if a > a_c
        K = 4*f_tip*sin(alpha)^2/(sigma*C_Thrust);
        a=0.5*(2+K*(1-2*a_c)-sqrt((K*(1-2*a_c)+2)^2+4*(K*a_c^2-1)));
    end;
    resultAngles(stationNumber) = alpha*180/pi-10;
    resultChordLength(stationNumber) = c;
    resultF_tip(stationNumber) = f_tip;

end;
%% Section 2.2
C_L_3d(:,1) = interpolationTable(18:61,2)+(c_l_design - interpolationTable(18:61,2))*f_cl_snel(3)
C_L_3d(:,2) = interpolationTable(18:61,2)+(c_l_design - interpolationTable(18:61,2))*f_cl_snel(5)


figure();
hold on;
plot(C_L_3d(:,1));
plot(C_L_3d(:,2));
hold off;
figure();
plot(resultF_tip);
figure();
hold on;
plot(f_cl_chhansen(2:10));
plot(f_cl_snel(2:10));
hold off;


