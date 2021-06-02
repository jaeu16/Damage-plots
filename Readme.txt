- damages_scatter_density_flex needs the densityScatter.m and the scatplot.m and the csv file named all_level_damages_flex.csv
	It plots it's results in the folder: \flexible\results from scatter density
	(same thing of course for _rig)
- in the folder \flexible you will find compute3D_damages_PO_flex needs the x_coordinate.csv, y_coordinate.csv, z_coordinate.csv and all_piers_macro_damages_pushover_updated
	It creates a pushover_damages.gif but you have to comment/uncomment the correct line so that you get one facade or the 3D (it is commented in the code)
	(same thing of course for _rig)
	!!! Please check the problem with the xticks() function !!!