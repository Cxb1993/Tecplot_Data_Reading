function [ data ] = tecplot_dat_read_v2( filename,meshtype,nlayers )
%tecplot_dat_read_v2 is an improved and simpler version of tecplot_dat_read
%   ChaoWang201702271302

[n_nodes,n_elms,vars,var_loc,fpst] = tecplot_dat_info(filename);
fid = fopen(filename,'r');
fseek(fid,fpst,'bof');

nvar = size(vars,1);
varlen = repmat(n_nodes,[nvar+1,1]); % Last variable ele_node_lst is not in the VARIABLES list
varlen(var_loc) = n_elms;
varlen(end) = n_elms*8; % For ele_node_lst

varlayer = repmat(nlayers+1,[nvar+1,1]);
varlayer(var_loc) = nlayers;
varlayer(end) = nlayers;

for ivar = 1:nvar
    [~] = fgetl(fid);
    temp = fscanf(fid,'%f',varlen(ivar));
    temp = reshape(temp,[varlen(ivar)/varlayer(ivar) varlayer(ivar)]);
    varnm = vars{ivar,1};
    varnm(isspace(varnm)) = [];
    eval(['data.' varnm '= temp;'])
    [~] = fgetl(fid);
end

[~]=fgetl(fid);
data.ele_node_lst = fscanf(fid,'%8d',n_elms*8);
% Prism element node list.
data.ele_node_lst = reshape(data.ele_node_lst,[8 n_elms/varlayer(end) varlayer(end)]);
data.ele_node_lst = permute(data.ele_node_lst,[2 1 3]);

% Triangular mesh node list.
if strcmp(meshtype,'tri')
    n_ele_node=3;
elseif strcmp(meshtype,'rect')
    n_ele_node=4;
end
mesh_node_lst=ones(n_elms/nlayers,n_ele_node,nlayers+1);
mesh_node_lst(:,:,1:end-1)=data.ele_node_lst(:,1:n_ele_node,:);
mesh_node_lst(:,:,end)=data.ele_node_lst(:,end-3:end-4+n_ele_node,end);

% For reading convenience by Python after being saved as .mat file
data.mesh_node_lst=permute(mesh_node_lst,[3 1 2]);
data.ele_node_lst=permute(data.ele_node_lst,[3 1 2]);

end

