function [n_nodes,n_elms,vars,var_loc,fpst]=tecplot_dat_info(filename)
%read_tecplot_dat_info Read info from Tecplot importable format *.dat file.
%   Reture number of nodes and elements, as well as file position.
%   ChaoWang201512052144

%   ChaoWang201512120853:
%   Function name changed from read_tecplot_dat_info to tecplot_dat_info

%   ChaoWang201702271110:
%   Codes added to return name of variables

%   ChaoWang201702271247:
%   Codes added to return variable location (at node or at center)
%   [n_nodes,n_elms,vars,var_loc,fpst]=tecplot_dat_info(filename)

fid=fopen(filename,'r');
while 1
    tline=fgetl(fid);
    if strcmp(tline(1:5),'TITLE')
        
    elseif strcmp(tline(1:9),'VARIABLES')
        var_info = tline;
    elseif strcmp(tline(1:4),'ZONE')
        zone_info=tline;
        break;
    end
end
% Get the name of variables
var_info = var_info(12:end);
vars = textscan(var_info,'%q','Delimiter',',');
vars = vars{1};

% Get the number of nodes and elements
expression=', N=';
[~,endIndex] = regexp(zone_info,expression);
n_nodes = sscanf(zone_info(endIndex+1:end), '%g', 1);
expression=', E=';
[~,endIndex] = regexp(zone_info,expression);
n_elms = sscanf(zone_info(endIndex+1:end), '%g', 1);
% Get variable location (at node or at center)
expression='VARLOCATION=([';
[~,endIndex] = regexp(zone_info,expression);
var_loc = textscan(zone_info(endIndex+1:end),'%d','Delimiter',',');
var_loc = var_loc{1};

% File position
fpst=ftell(fid);

fclose(fid);

end