%This code accepts excel files to read as input variables for fuselage, using the Air
%Race Ree LateX doc as the source of all code.
%By R&J - ayyyyyy
%Last updated: 03/08/2019
%Praise Errikos and don't forget to
clear; clc;
%example xlrs read format, uses an example excel spreadsheet for initial
%variables
%Format: File name, Sheet number, #rows + 1:column
mainArray = xlsread('example.xlsx', 1, '30:1');
%Below variables follow the list from lateX, fuselage
l_n = mainArray(1); %Fuselage Nose Cone length
l_c = mainArray(2); %Fuselage Center section length
l_t = mainArray(3); %Fuselage tail length
l_v = mainArray(4); %Length of item used as volume in fuselage
R   = mainArray(5); %Average Fuselage radius (Smax/Pi = R)
R_v = mainArray(6); %Average Radius of item used as volume in fuselage
Z_b = mainArray(7); %Perpendicular distance from remote axes XY Plane to fuselage centerline
XS4 = mainArray(8); %Perpendicular distance from remote axes YZ Plane to leading edge of surface root chord
W_s = mainArray(9); %Weight of Fuselage Structure
W_pc= mainArray(10);%Total weight of pointmasses in Fuselage Center Section
W_vo= mainArray(11);%Weight of one Volume of Mass
W_pnc= mainArray(12);%Total weight of point masses in nose and tail cone 
W_t = mainArray(13);%Weight of Fuselage tail cone (Structure only)
W_p = mainArray(14);%Weight of one Point mass
W_n = mainArray(15);%Weight of Fuselage Nose Cone
W_c = mainArray(16);%Weight of Fuselage centre section
X   = mainArray(17);%Perpendicular distance from Z axis to aircraft CG
Y   = mainArray(18);%Distance from some reference point to surface spanwise center of gravity
Z   = mainArray(19);%Perpendicular distance from X axes to aircraft center of gravity

%Raymer Variables
S_Fus=mainArray(20);%Fuselage Wetted area in ft^2
n_z = mainArray(21);%Maximum wing loading (6G) 
W_O = mainArray(22);%Total gross weight (240 kg = 529.109 lbs)
l_HT= mainArray(23);%Length of Horizontal Tail weight
l_Fus=mainArray(24);%Fuselage structure length (Bulkhead to aft) (ft)
d_Fus=mainArray(25);%Fuselage structure depth (ft)
q =   mainArray(26);%dynamic pressure at cruise (lb/ft^2)
V_p = mainArray(26);%Volume of pressurized cabin (ft^3)
delta_P = mainArray(27);%Cabin pressure differential (Psi)
W_UAV= mainArray(28);%Weight of uninstalled avionics
b    = mainArray(29);%Wingspan in ft (DON'T CHANGE IT TO m THE CALCULATIONS DEPEND ON IT)
CREW_cg=mainArray(30);

%Raymer Predicted Fuselage Weight in (lbs) * .4536 = (kg)
W_Fus = (0.052*(S_Fus^1.086)*((n_z*W_O)^.177)*(l_HT^-.051)*((l_Fus/d_Fus)^-.072)*(q^.241) + 11.9*(V_p*delta_P)^.271)*.4536;
%Raymer Flight control system Weight (W_CTRL)
W_CTRL =( .053*(l_Fus^1.536)*(b^.371)*(n_z*W_O*10^-4)^.80 )*.4536;
%Raymer Avionics Systems Weight (W_AV)
W_AV = (2.117*W_UAV^.933)*.4536;
%Raymer Electrical System Weight (W_EL)
W_EL = (12.57*(W_Fus + W_AV))*.4536;
%Raymer Furnishings Weight (W_Furn)
W_Furn = (.0582*W_O-65)*.4536;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fuselage Inertial moments about remote axes (Ix, Iy, Iz, Ixz)
I_1x  = (.5*R^2)*(W_n + 2*W_c + W_t) + W_s*(Z_b)^2;
I_1y  = .25*(R^2)*(W_n + 2*W_c + W_t) + (l_n^2)*(.5*W_n + W_c + W_t) + (l_c^2)*(W_c/3 + W_t) + (l_t^2)*(W_t/6) + l_c*l_n*(W_c + 2*W_t) + (2/3)*l_t*l_c*W_t + (2/3)*l_t*l_n*W_t + W_t*Z_b*(l_n + l_c + .25*l_t);
I_1z  = I_1y - W_s*(Z_b)^2;
I_1xz = W_n*(.75*l_n*Z_b) + W_c*Z_b*(l_n + .5*l_c) + W_t*Z_b*(l_n + l_c + .25*l_t);

%Fuselage Distributed Contents
W_dc = W_CTRL + W_EL + W_Fus + .3*W_AV;
%Need CREW_cg
I_2x  = W_dc*R^2 + W_dc*Z_b^2;
I_2y  = .5*W_dc*(R^2 + (1/6)*(XS4-CREW_cg)^2) + W_dc*(.5*(XS4 - CREW_cg) + CREW_cg)^2 + W_dc*Z_b^2;
I_2z  = I_1y - W_dc*Z_b^2;
I_2xz = .5*W_dc*Z_b*(XS4 + CREW_cg);

%Fuselage Volumes of mass
I_3x  = W_vo*R_v^2 + W_vo*Z^2;
I_3y  = .5*W_vo*( R_v^2 + (l_v^2)/6 ) + W_vo(X^2 + Z^2);
I_3z  = .5*W_vo*(R_v^2 + (l_v^2)/6) + W_vo*X^2;
I_3xz = W_vo*X*Z;

%Fuselage Point Masses
    %More work needs to be done to figure out what to do with this sigma
    %ridden hellscape
I_4x  = .5*W_p*R^2 + .3*W_pnc*R^2 + (W_pc + W_pnc)*Z_b^2;
I_4y  = W_p*(X^2 + Z^2);
I_4z  = W_p*(X^2 + Y^2);
I_4xz = W_p*X*Z;