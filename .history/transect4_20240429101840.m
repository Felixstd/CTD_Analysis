%transect one
clear all, close all, clc;
filename = 'T4_p1.mat';
date = '12-09-2023 00:30';
figname = '12_09_2023_transect4';
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
%% Profiles
P1 = {18090, 19284, 18490};
P2 = {25400, 26718, 25739};
P3 = {35706, 37152, 36129};
P4 = {42960, 43663, 43292};
P5 = {49979, 51380, 50417 };
P6 = {60795, 61815, 61130};
P7 = {71230, 72692, 71609 };
P8 = {82650, 84106, 83041};
P9 = {92600, 93682, 92965};
P10 = {103540, 105740, 104032};
Liste_P = {P1, P2, P3, P4, P5, P6, P7, P8, P9, P10};
Labels = {'T4_p1', 'T4_p2', 'T4_p3', 'T4_p4', 'T4_p5', 'T4_p6', 'T4_p7', 'T4_p8', 'T4_p9', 'T4_p10'};

C1 = {68+20.462/60, 360-167-00.764/60};
C2 = {68+20.401/60, 360-167-05.037/60};
C3 = {68+20.357/60, 360-167-12.147/60};
C4 = {68+20.373/60, 360-167-16.593/60};
C5 = {68+20.401/60, 360-167-20.759/60};
C6 = {68+20.390/60, 360-167-28.114/60};
C7 = {68+20.574/60, 360-167-34.657/60};
C8 = {68+20.473/60, 360-167-41.892/60};
C9 = {68+20.617/60, 360-167-48.134/60};
C10 = {68+20.482/60, 360-167-55.254/60};

Coords  = {C1, C2, C3, C4, C5, C6, C7, C8, C9, C10};
Dist = [];Az = [];
for i=1:length(Coords)
    [a,b] = distance(Coords{i}{1}, Coords{i}{2}, Coords{1}{1}, Coords{1}{2});
    Dist(i) = a*60*1.852;
end
Dist(i+1) = Dist(i)+1.852;


%legend()
%% Interpolation
CTi = []; ASi=[]; Sig0i=[];
smo = 5;
for i=1:length(Liste_P)
    CTi(i,1:170) = interp1(smooth(Depth(Liste_P{i}{1}:Liste_P{i}{3}), smo), CT(Liste_P{i}{1}:Liste_P{i}{3}), 1:170, 'linear');
    ASi(i,1:170) = interp1(smooth(Depth(Liste_P{i}{1}:Liste_P{i}{3}), smo), AS(Liste_P{i}{1}:Liste_P{i}{3}), 1:170, 'linear');
    Sig0i(i,1:170) = interp1(smooth(Depth(Liste_P{i}{1}:Liste_P{i}{3}), smo), Sig0(Liste_P{i}{1}:Liste_P{i}{3}), 1:170, 'linear');
end
CTi(i+1,1:170) = interp1(smooth(Depth(Liste_P{i}{1}:Liste_P{i}{3}), smo), CT(Liste_P{i}{1}:Liste_P{i}{3}), 1:170, 'linear');
ASi(i+1,1:170) = interp1(smooth(Depth(Liste_P{i}{1}:Liste_P{i}{3}), smo), AS(Liste_P{i}{1}:Liste_P{i}{3}), 1:170, 'linear');
Sig0i(i+1,1:170) = interp1(smooth(Depth(Liste_P{i}{1}:Liste_P{i}{3}), smo), Sig0(Liste_P{i}{1}:Liste_P{i}{3}), 1:170, 'linear');

%% Plots
Tmax = 10;
Tmin = -1;

Smin = 22;
Smax  = 33;

Rmin = 20;
Rmax = 28;

init = 1;
fin = length(Temperature);
%

figure()
subplot(1,3,1)
for i =1:length(Liste_P)
    plot(Temperature(Liste_P{i}{1}:Liste_P{i}{2}), Depth(Liste_P{i}{1}:Liste_P{i}{2}), DisplayName=Labels{i}), axis ij;
    hold on
end
xlim([Tmin, Tmax])
xlabel('Temperature')
ylabel('Depth')
title(date)
legend('Location', 'northwest')
    
subplot(1,3,2)
for i =1:length(Liste_P)
    plot(AS(Liste_P{i}{1}:Liste_P{i}{2}), Depth(Liste_P{i}{1}:Liste_P{i}{2})), axis ij;
    hold on
end
xlim([Smin, Smax])
xlabel('Abs. Salinity')
ylabel('Depth')

subplot(1,3,3)  
for i =1:length(Liste_P)
    plot(Sig0(Liste_P{i}{1}:Liste_P{i}{2}), Depth(Liste_P{i}{1}:Liste_P{i}{2})), axis ij;
    hold on
end

xlim([Rmin, Rmax])
xlabel('Pot. density')
ylabel('Depth')

saveas(gcf, ['../figures/' figname '.png'])


%% Pcolorplot
range_colorbarT = [-2 8];
range_colorbarS = [25, 33];
range_colorbarR = [20, 27];

figure1 = figure('name', 'Dissip properties', 'units', 'normalized', 'outerposition',[0 0 1 1], 'visible', 'on');
set(gcf, 'color', 'w')
subplot(3,1,1)
% color map T
colormap(fake_parula());
pcolor(Dist, 1:60, CTi(:, 1:60)'), shading flat, axis ij
caxis(range_colorbarT)
c = colorbar;
ylabel('Temp.')

subplot(3,1,2)
% color map s
colormap(fake_parula());
pcolor(Dist, 1:60, ASi(:, 1:60)'), shading flat, axis ij
caxis(range_colorbarS)
c = colorbar;
ylabel('Abs. Sal.')

subplot(3,1,3)
% color map R
colormap(fake_parula());
pcolor(Dist, 1:60, Sig0i(:, 1:60)'), shading flat, axis ij
caxis(range_colorbarR)
c = colorbar;
xlabel('Distance to first point [km]')
ylabel('Pot. density')

saveas(gcf, ['../figures/' figname '_colormaps' '.png'])

%% Contourf pdens
figure() % color map R
colormap(fake_parula());
contourf(Dist(1:end-1), 1:60, CTi(1:end-1, 1:60)', 'levels', 0.5), shading flat, axis ij
caxis([-2, 5])
%hold on
%contour(Dist(1:end-1), 1:170, Sig0i(1:end-1, 1:170)', 'levels', 0.25, 'Linewidth', 1), shading flat, axis ij
c = colorbar;
xlabel('Distance to first point [km]')
ylabel('Temp. ')
saveas(gcf, ['../figures/' figname '_contours_T' '.png'])

figure() % color map R
colormap(fake_parula());
contourf(Dist(1:end-1), 1:60, ASi(1:end-1, 1:60)', 'levels', 0.5), shading flat, axis ij
caxis([25 33])
%hold on
%contour(Dist(1:end-1), 1:170, Sig0i(1:end-1, 1:170)', 'levels', 0.25, 'Linewidth', 1), shading flat, axis ij
c = colorbar;
xlabel('Distance to first point [km]')
ylabel('Abs. Sal. ')
saveas(gcf, ['../figures/' figname '_contours_S' '.png'])



figure() % color map R
colormap(fake_parula());
contourf(Dist(1:end-1), 1:60, Sig0i(1:end-1, 1:60)', 'levels', 0.25), shading flat, axis ij
caxis([20 27])
%hold on
%contour(Dist(1:end-1), 1:170, Sig0i(1:end-1, 1:170)', 'levels', 0.25, 'Linewidth', 1), shading flat, axis ij
c = colorbar;
xlabel('Distance to first point [km]')
ylabel('Pot. density')
saveas(gcf, ['../figures/' figname '_contours_R' '.png'])


%% Anomaly plot
range_colorbarT = [-1.5, 1.5];
range_colorbarS = [-1.5, 1.5];
range_colorbarR = [-1.5, 1.5];

figure1 = figure('name', 'Dissip properties', 'units', 'normalized', 'outerposition',[0 0 1 1], 'visible', 'on');
set(gcf, 'color', 'w')
subplot1 = subplot(3,1,1);
% color map T
colormap(fake_parula());
pcolor(Dist, 1:170, CTi(:, 1:170)' - CTi(5,:)'), shading flat, axis ij
caxis(range_colorbarT)
c = colorbar;
ylabel('Temp.')

subplot2 = subplot(3,1,2);
% color map s
pcolor(Dist, 1:170, ASi(:, 1:170)' - ASi(5,:)'), shading flat, axis ij
caxis(range_colorbarS)
c = colorbar;
ylabel('Abs. Sal.')

subplot3 = subplot(3,1,3);
% color map R
%colormap(fake_parula());
pcolor(Dist, 1:170, Sig0i(:, 1:170)' - Sig0i(5,:)'), shading flat, axis ij
caxis(range_colorbarR)
c = colorbar;
xlabel('Distance to first point [km]')
ylabel('Pot. density')

saveas(gcf, ['../figures/' figname '_colormaps_anomalies' '.png'])
%% Save matfiles_per_point

for i =1:length(Liste_P)
    RBR_current = RBR;
    RBR_current.data = RBR_current.data(Liste_P{i}{1}:Liste_P{i}{2}, :);
    RBR_current.sampletimes = RBR_current.sampletimes(Liste_P{i}{1}:Liste_P{i}{2});
    save(['../data/' Labels{i} '.mat'], "RBR_current");
end