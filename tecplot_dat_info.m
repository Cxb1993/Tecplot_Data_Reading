function [n_nodes,n_elms,fpst]=tecplot_dat_info(filename)
%read_tecplot_dat_info Read info from Tecplot importable format *.dat file.
%   Reture number of nodes and elements, as well as file position.
%   ChaoWang201512052144

%   ChaoWang201512120853:
%   Function name changed from read_tecplot_dat_info to tecplot_dat_info
fid=fopen(filename,'r');
while 1
    tline=fgetl(fid);
    if strcmp(tline(1:5),'TITLE')
        
    elseif strcmp(tline(1:9),'VARIABLES')
        
    elseif strcmp(tline(1:4),'ZONE')
        zone_info=tline;
        break;
    end
end

expression=', N=';
[~,endIndex] = regexp(zone_info,expression);
n_nodes = sscanf(zone_info(endIndex+1:end), '%g', 1);
expression=', E=';
[~,endIndex] = regexp(zone_info,expression);
n_elms = sscanf(zone_info(endIndex+1:end), '%g', 1);

fpst=ftell(fid);

fclose(fid);

end