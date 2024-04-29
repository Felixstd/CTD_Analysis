clear all, close all, clc;
filename = '12_09_2023_transect4.mat';
%02_09_2023_21_18_essai_1
%02_09_2023_22_02_essai2
%06_09_2023_04_00_sample1
%06_09_2023_16_44_sample2 -> transect1
%06_09_2023_20_00_sample3
%06_09_2023_23_25_sample4
%09_09_2023_transect2
%09_09_2023_transect3
%12_09_2023_transect4


date = '12-09-2023 00:20';
figname = '12_09_23_transect_4';
pression_atm = 992; 
Latitude = 70; 
Longitude= -130;
RBR = load([filename]).RBR;

Time = RBR.sampletimes;
Salinity = RBR.data(:,5 );
Pressure =  RBR.data(:,3 ); %correction a ajouter
Depth =  RBR.data(:,4 );
Temperature =  RBR.data(:,2 );


[AS, in_ocean] = gsw_SA_from_SP(Salinity, Pressure,Longitude,Latitude);
CT = gsw_CT_from_t(AS, Temperature,Pressure);
Sig0 = gsw_sigma0(AS, CT);
%% Plots
Tmax = 10;
Tmin = 0.5;

Smin = 25;
Smax  = 35;

Rmin = 20;
Rmax = 27;

init = 1;
fin = length(Temperature);
%

figure()
subplot(1,3,1)
plot(Temperature(init:fin), Depth(init:fin)), axis ij;
xlim([Tmin, Tmax])
xlabel('Temperature')
ylabel('Depth')
title(date)
    
subplot(1,3,2)
plot(AS(init:fin), Depth(init:fin)), axis ij;
xlim([Smin, Smax])
xlabel('Abs. Salinity')
ylabel('Depth')

subplot(1,3,3)  
plot(Sig0(init:fin), Depth(init:fin)), axis ij;
xlim([Rmin, Rmax])
xlabel('Pot. density')
ylabel('Depth')

saveas(gcf, ['../figures/' figname '.png'])