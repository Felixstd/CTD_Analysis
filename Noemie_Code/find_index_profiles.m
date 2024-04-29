clear all, close all, clc;
filename = '../data/12_09_2023_transect4.mat';
pression_atm = 992;
Latitude = 70; 
Longitude= -150;
RBR = load([filename]).RBR;

Time = RBR.sampletimes;
Salinity = RBR.data(:,5 );
Pressure =  RBR.data(:,3 ); %correction a ajouter
Depth =  RBR.data(:,4 );
Temperature =  RBR.data(:,2 );


[AS, in_ocean] = gsw_SA_from_SP(Salinity, Pressure,Longitude,Latitude);
CT = gsw_CT_from_t(AS, Temperature,Pressure);
Sig0 = gsw_sigma0(AS, CT);

%% plot time serie

plot(Depth)

P1 = {17745, 19284, 18520};
P2 = {24867, 26718, 25739};
P3 = {35706, 37152, 36129};
P4 = {42901, 43663, 43292};
P5 = {48979, 51380, 50417 };
P6 = {60550, 61815, 61166};
P7 = {71074, 72692, 71609 };
P8 = {82083, 84106, 83041};
P9 = {92156, 93682, 92975};
P10 = {103520, 105740, 104032};
