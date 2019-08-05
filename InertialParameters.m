%This code accepts excel files to read as input variables for fuselage, using the Air
%Race Ree LateX doc as the source of all code.
%By R&J - ayyyyyy
%Last updated: 03/08/2019
%Praise Errikos and don't forget to
clear; clc;
%example xlrs read format, uses an example excel spreadsheet for initial
%variables
%Format: File name, Sheet number, #rows + 1:column
mainArray = xlsread('example.xlsx', 1, '18:1');
%Below variables follow the list from lateX, fuselage
l_n = mainArray(1);
l_c = mainArray(2);
l_t = mainArray(3);
l_v = mainArray(4);
R   = mainArray(5);
R_v = mainArray(6);
Z_b = mainArray(7);
XS4 = mainArray(8);
W_s = mainArray(9);
W_pc= mainArray(10);
W_vo= mainArray(11);
W_pnc= mainArray(12); %what are you looking at I know its off but what can i do huh :(
W_t = mainArray(13);
W_p = mainArray(14);
W_n = mainArray(15);
W_c = mainArray(16);
X   = mainArray(17);
Y   = mainArray(18);
Z   = mainArray(19);

%Raymer Predicted Fuselage Weight in (lbs) * .4536 = (kg)
%W_Fus = 0.052*(S_Fus^1.086)*((n_z*W_o)^.177)*(l_HT^-.051)*((l_Fus/d_Fus)^-.072)*(q^.241) + 11.9*(V_p*delta_P)^.271;
%Raymer equation includes many variables that are different, wrote equation
%but needs the other variables to work. 
%Also note that all variables of length or area are given in ft. USA! USA!

%Fuselage Inertial moments about remote axes (Ix, Iy, Iz, Ixz)
I_1x  = (.5*R^2)*(W_n + 2*W_c + W_t) + W_s*(Z_b)^2;
I_1y  = .25*(R^2)*(W_n + 2*W_c + W_t) + (l_n^2)*(.5*W_n + W_c + W_t) + (l_c^2)*(W_c/3 + W_t) + (l_t^2)*(W_t/6) + l_c*l_n*(W_c + 2*W_t) + (2/3)*l_t*l_c*W_t + (2/3)*l_t*l_n*W_t + W_t*Z_b*(l_n + l_c + .25*l_t);
I_1z  = I_y - W_s*(Z_b)^2;
I_1xz = W_n*(.75*l_n*Z_b) + W_c*Z_b*(l_n + .5*l_c) + W_t*Z_b*(l_n + l_c + .25*l_t);

%Fuselage Distributed Contents
%Need W_dc & CREW_cg
I_2x  = W_dc*R^2 + W_dc*Z_b^2;
I_2y  = .5*W_dc*(R^2 + (1/6)*(XS4-CREW_cg)^2) + W_dc*(.5*(XS4 - CREW_cg) + CREW_cg)^2 + W_dc*Z_b^2;
I_2z  = I_y - W_dc*Z_b^2;
I_2xz = .5*W_dc*Z_b*(XS4 + CREW_cg);

%Fuselage Volumes of mass
I_3x  = W_vo*R_v^2 + W_vo*Z^2;
I_3y  = .5*W_vo*(R_v^2 + (l_v^2)/6) + W_vo(X^2 + Z^2);
I_3z  = .5*W_vo*(R_v^2 + (l_v^2)/6) + W_vo*X^2;
I_3xz = W_vo*X*Z;

%Fuselage Point Masses
    %More work needs to be done to figure out what to do with this sigma
    %ridden hellscape
I_4x  = .5*W_p*R^2 + .3*W_pnc*R^2 + (W_pc + W_pnc)*Z_b^2;
I_4y  = W_p*(X^2 + Z^2);
I_4z  = W_p*(X^2 + Y^2);
I_4xz = W_p*X*Z;