clear all, close all, clc;

fig = figure(1);                                                        % figure handle
set(fig,'Color','w');                                                   % box color                                         
worldmap([65 86],[-130 -50])
axesm('eqaazim', 'MapLatLimit',[60 90]);                                % Projection Definition
axis off;                                                               % No box around figure
framem on;                                                              % Make circular frame around the map
gridm on;                                                               % show Lat-lon grid
mlabel on;                                                              % meridian label
plabel on;                                                              % parallel label
setm(gca,'MLabelParallel',0);                                           % Label orientation
title('Monthly mean SIE Sept. 2012');                                   % title
%geoshow(LAT,LON,sicEASE','DisplayType','texturemap');                   % SIC pcolor
geoshow('landareas.shp', 'FaceColor', 'white');                         % Continent Color
%geoshow(Buoy(:,2),Buoy(:,3),'LineStyle','-','Marker','.','Color','r');  % Buoy Traj
