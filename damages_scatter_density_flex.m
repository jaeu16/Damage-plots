% Plot of the damages according to local, macro and global scale
% Create a scatter with density for each fecade (local and macro) and for
% all the building (global).
% This code should be placed in the "op_model_" folder and takes the all_level_damages.csv
% file as input. If you change the data frame table for this csv file,
% please adapt the "Datas" lines because "format" is dependent of the
% number of columns of the csv file.

% This code need two functions that can be found in the File Exchange mathworks :
% densityScatter.m
% https://de.mathworks.com/matlabcentral/fileexchange/56569-density-scatter-plot

% scatplot.m
% https://www.mathworks.com/matlabcentral/fileexchange/8577-scatplot



%% Cleaning
clc
clear all
close all

%% Plot font
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter', 'latex');

%% Datas
fid = fopen('all_level_damages_flex.csv'); % This function open the file specified in the arg
format = '%s %f %f %f %f %f %f %f %f %f %f %f';
hlines = 1;
delim = ',';
data = textscan(fid,format,'HeaderLines',hlines,'Delimiter',delim,'MultipleDelimsAsOne',1,'TreatAsEmpty','-');
fclose(fid);
fund_period = importdata('../modes/Periods.txt');

%% Inputs for plots
method = 'circles';
radius = 0.5;
N = 40;
n = 5;
po = 2;
ms = 20;

%% Plots
groundMotionName = data{:,1};
Sa = data{:,3};
local_E_DL = data{:,4};
local_W_DL = data{:,5};
local_N_DL = data{:,6};
local_S_DL = data{:,7};
macro_E_DL = data{:,8};
macro_W_DL = data{:,9};
macro_N_DL = data{:,10};
macro_S_DL = data{:,11};
global_DL = data{:,12};

local_DL = [local_E_DL local_W_DL local_N_DL local_S_DL];
macro_DL = [macro_E_DL macro_W_DL macro_N_DL macro_S_DL];

maxLocal = max(local_DL');
maxMacro = max(macro_DL');

%% 2D density plot
% Local scale
densityPlotScatter([Sa'; local_E_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Local damages, east fecade')
saveas(gcf,'flexible\results from scatter density\Local damages, east fecade.jpg')
densityPlotScatter([Sa'; local_W_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Local damages, west fecade')
saveas(gcf,'flexible\results from scatter density\Local damages, west fecade.jpg')
densityPlotScatter([Sa'; local_N_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Local damages, north fecade')
saveas(gcf,'flexible\results from scatter density\Local damages, north fecade.jpg')
densityPlotScatter([Sa'; local_S_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Local damages, south fecade')
saveas(gcf,'flexible\results from scatter density\Local damages, south fecade.jpg')
densityPlotScatter([Sa'; maxLocal], 'Sa $[m/s^2]$', '$DL_i$', 'Max local damages')
saveas(gcf,'flexible\results from scatter density\Max local damages.jpg')

% Macro scale
densityPlotScatter([Sa'; macro_E_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Macro damages, east fecade')
saveas(gcf,'flexible\results from scatter density\Macro damages, east fecade.jpg')
densityPlotScatter([Sa'; macro_W_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Macro damages, west fecade')
saveas(gcf,'flexible\results from scatter density\Macro damages, west fecade.jpg')
densityPlotScatter([Sa'; macro_N_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Macro damages, north fecade')
saveas(gcf,'flexible\results from scatter density\Macro damages, north fecade.jpg')
densityPlotScatter([Sa'; macro_S_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Macro damages, south fecade')
saveas(gcf,'flexible\results from scatter density\Macro damages, south fecade.jpg')
densityPlotScatter([Sa'; maxMacro], 'Sa $[m/s^2]$', '$DL_i$', 'Max macro damages')
saveas(gcf,'flexible\results from scatter density\Max macro damagese.jpg')

% Global scale
densityPlotScatter([Sa'; global_DL'], 'Sa $[m/s^2]$', '$DL_i$', 'Global damages')
saveas(gcf,'flexible\results from scatter density\Global damages.jpg')
% Macro vs Local
graphDensity(maxLocal,maxMacro,method,radius,N,n,po,ms, '$DL_i$ Local', '$DL_i$ Macro', 'Local vs Macro')
saveas(gcf,'flexible\results from scatter density\Macro vs local.jpg')
% Global vs Local
graphDensity(maxLocal,global_DL',method,radius,N,n,po,ms, '$DL_i$ Local', '$DL_i$ Global', 'Local vs Global')
saveas(gcf,'flexible\results from scatter density\Global vs Local.jpg')
% Macro vs Global
graphDensity(maxMacro,global_DL',method,radius,N,n,po,ms, '$DL_i$ Macro', '$DL_i$ Global', 'Macro vs Global')
saveas(gcf,'flexible\results from scatter density\Macro vs Global.jpg')


%% functions
% it only plot the graph, it is for reduce the number of lines

function graph = densityPlotScatter(X,xLabel,yLabel,graphTitle)
    figure()
    graph = densityScatter(X)
    xlabel(xLabel)
    ylabel(yLabel)
    title(graphTitle)
    grid on
    colormap(flipud(hot))
    colorbar
end

function graph = graphDensity(xValues, yValues,method, radius, N, n, po, ms, xLabel, yLabel, graphTitle)
    figure()
    graph = scatplot(xValues,yValues,method,radius,N,n,po,ms)
    title(graphTitle)
    xlabel(xLabel)
    ylabel(yLabel)
end




