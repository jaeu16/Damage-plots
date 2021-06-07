% This code compute a view of macro damages of the structure for each piers
% It should be placed where the csv file all_piers_macro_damages_NLA_updated.csv
% is placed (in "op_model_" folder). If it's the case you can run it, if
% not, please adapt the line #37. A gif file is also created.

%% Cleaning
clc
clear all
close all

%% Name of the crated GIF file
filename = 'pushover_damages.gif';

%% Plot font
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter', 'latex');

%% Inputs
% You can change the value of pauseTime to have more or less spacing
% between figures
pauseTime = 0.05;

% Coordinates of axis
units = '[mm]'; % only for the graph's label

% Scatter color for different DL (from 0 to 4)
colorSet = [0 125/255 215/255
    0 210/255 125/255
    235/255 215/255 0
    235/255 150/255 0
    130/255 0 0];

%% Datas
% just read the csv file in the current directory
datas = readtable('all_piers_macro_damages_pushover_updated.csv');
pierID = datas{1,3:end};
load = datas{2:end,2};
DL = datas{2:end,3:end};

% Coordinates of the piers
x_coordinates = readtable('x_coordinates.csv');
y_coordinates = readtable('y_coordinates.csv');
z_coordinates = readtable('z_coordinates.csv');

% Take only the values, not the title
x_po = x_coordinates{:,2};
y_po = y_coordinates{:,2};
z_po = z_coordinates{:,2};

% Create a matrix to "transform" axis in coordinates
for i = 1:length(pierID)
    pierIDstr = num2str(pierID(i));
    x(i) = str2double(pierIDstr(6:7));
    y(i) = str2double(pierIDstr(4:5));
    z(i) = str2double(pierIDstr(2:3));
    x_coord(i) = x_po(x(i));
    y_coord(i) = y_po(y(i));
    z_coord(i) = z_po(z(i));
end

% just the plot
h = figure('Renderer', 'painters', 'Position', [100 100 900 600]);
for k = 1:size(load)
    for kk = 1:length(pierID)
        damageColor(kk,:) = colorSet(DL(k,kk)+1,:);
    end
     %%%%%% scatter of the facade where the y coordinate is 0 or 11300
    x_coord_fac0=[];
    z_coord_fac0=[];
    DL_fac0=[];
    damageColor_fac0=[];
    x_coord_fac11300=[];
    z_coord_fac11300=[];
    DL_fac11300=[];
    damageColor_fac11300=[];
    for i=1:length(x_coord)
        if y_coord(i)==0
            x_coord_fac0=[x_coord_fac0 x_coord(i)];
            z_coord_fac0=[z_coord_fac0 z_coord(i)];
            DL_fac0=[DL_fac0 DL(:,i)];
            damageColor_fac0=[damageColor_fac0; damageColor(i,:)];
        elseif y_coord(i)==11300
            x_coord_fac11300=[x_coord_fac11300 x_coord(i)];
            z_coord_fac11300=[z_coord_fac11300 z_coord(i)];
            DL_fac11300=[DL_fac11300 DL(:,i)];
            damageColor_fac11300=[damageColor_fac11300; damageColor(i,:)];
        end        
    end
    
    %decomment next line for having the 3D scatter
    scatter3(x_coord', y_coord', z_coord',20*(DL(k,:)'+1), damageColor, 'LineWidth', 1)
    %other example ?
    %scatter3(x', y', z',20*(modifiedDatas(k,:)'+1), modifiedDatas(k,:)'.*[256/4 0 0], 'LineWidth', 1)
   
    %decomment next line for having the scatter of facade where y=0
    %scatter(x_coord_fac0', z_coord_fac0', 20*(DL_fac0(k,:)'+1), damageColor_fac0, 'LineWidth', 1)
    
    %decomment next line for having the scatter of facade where y=11300
    %scatter(x_coord_fac11300', z_coord_fac11300', 20*(DL_fac11300(k,:)'+1), damageColor_fac11300, 'LineWidth', 1)
   
    set(gca, 'xTick', 1000, 'yTick', 1000)

    lastwarn('') % Clear last warning message
    title(['Load : ' num2str(load(k)) ' [kN]'])
    [warnMsg, warnId] = lastwarn;
    if ~isempty(warnMsg)
        title(['Load : ' load(k) ' [kN]'])
    end
    xlabel(['x ' units])
    ylabel(['y ' units])
    zlabel(['z ' units])
    set(gca,'XLim',[min(x_coord) max(x_coord)],'YLim',[min(y_coord) max(z_coord)],'ZLim',[0 max(z_coord)])
    xticks(x_po(1:length(x_po)-1));
    yticks(y_po(1:length(y_po)-1));
    zticks(z_po(1:length(z_po)-1));
    
    leg = zeros(5, 1);
    hold on
    leg(1) = scatter3(NaN,NaN,NaN,20,colorSet(1,:), 'LineWidth', 1);
    leg(2) = scatter3(NaN,NaN,NaN,40,colorSet(2,:), 'LineWidth', 1);
    leg(3) = scatter3(NaN,NaN,NaN,60,colorSet(3,:), 'LineWidth', 1);
    leg(4) = scatter3(NaN,NaN,NaN,80,colorSet(4,:), 'LineWidth', 1);
    leg(5) = scatter3(NaN,NaN,NaN,100,colorSet(5,:), 'LineWidth', 1);
    hold off
    legend(leg, 'DL0','DL1','DL2','DL3','DL4');
    
    grid on
    drawnow
    pause(pauseTime)
    
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if k == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
