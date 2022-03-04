%----------------------------initialization ---------------------------
clear variables; close all; % clean up
global basename             % global is required in context with MODPATH

basename = 'Q1'; % name of model and basename of all its files

% delete past modflow input files generated by mflab
delete([basename,'.BAS'],[basename,'.BCF'],[basename,'.BGT'],...
       [basename,'.DDN'],[basename,'.DIS'],[basename,'.EVT'],...
       [basename,'.HDS'],[basename,'.FM2000.LST'],[basename,'.OC'],...
       [basename,'.PCG'],[basename,'.WEL'],[basename,'.CHD'],...
       [basename,'.LPF'],[basename,'.FM2005.LST'])

%-------------------------nodal coordinates ---------------------------
% input x coordinates of all nodes
xGr = 0:10:100;
% input y coordinates of all nodes
yGr = 0:10:10;
% input z coordinates of all nodes
% for the tutorial question 1 we set zGr as two layers rather 
% than one layer for the purpose of avoiding one bug in mflab
% one can test this bug by setting the domain as one layer.
% this bug will not affect tutorial question 2 and the project.
zGr = 0:-10:-20;

% gridObj(xGr,yGr,zGr) is a mflab function to create calculation domain 
%     used by modflow. xGr, yGr and zGr are respective arrays indicating 
%     respectively the x y and z coordinates of the nodes
gr  = gridObj(xGr,yGr,zGr);

%--------------------------parameters ---------------------------------
% if IBOUND > 0, node is active(i.e., modflow will calculate its hydraulic head)
% if IBOUND ==0, the hydraulic head of this node will be fixed 
                     % to its initial value
% if IBOUND <0,  node is inactive		    
% gr.const is a function in mflab that create a matrix according to the size
% of domain, with fixed value
IBOUND =gr.const(3);
IBOUND(1,1,1)=1;        %identifiy the node with time-variant head boundary

% initial hydraulic head
STRTHD = gr.const(0);


% vertical hydraulic conductivity see page 58 of mf manual 2000
% VCONT has to be specified if multiple layer is present.
VCONT      = gr.const(0.06);

% horizontal hydraulic condcutivity
HY      = gr.const(0.06);

% first and second storage coefficient
SF1      = gr.const(0.25);
SF2      = gr.const(0.25);


% bcnZone is a mflab function to creat objects for time-variant 
% specified-head function (i.e., CHD package)

% zoneCHD= {A, B, C} 
% A - the IBOUND number of the cell that will be used as
% time-variant specified-head cell
% B - the hydraulic head of the cell at the beginning 
%      of the first stress period
% C - the hydraulic head of the cell at the end
%      of the first stress period
zoneCHD = {1,-5,-5};


% Creat CHD object
% use help bcnZone to see more details
CHD = bcnZone(basename,'CHD',IBOUND,zoneCHD);


% CHD{2}(5) - the hydraulic head at the beginning of 
%             the second stress period
% CHD{2}(6) - the hydraulic head at the end of 
%             the second stress period
% CHD{3}(5) - the hydraulic head at the beginning of 
%             the third stress period
% CHD{3}(6) - the hydraulic head at the end of 
%             the third stress period

CHD{2}(5)= -0;
CHD{2}(6)= -0;

CHD{3}(5)= -5;
CHD{3}(6)= -5;




