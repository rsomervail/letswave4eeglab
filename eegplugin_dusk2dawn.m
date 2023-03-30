
% eegplugin_letswave4eeglab() - a wrapper to plug-in dusk2dawn into EEGLAB. 
% 
%
% letswave4eeglab
% Author: Richard Somervail, Istituto Italiano di Tecnologia, 2023
%           www.iannettilab.net
%%  
function vers = eegplugin_dusk2dawn(fig,try_strings,catch_strings)

vers = '1.0.0';
p = fileparts(which('eegplugin_letswave4eeglab'));

% DEFINITIONS
overwrite = '[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET); eeglab redraw; ';
% titleCol = [0.5 * ones(1,3)];
titleCol = [0.0, 0, 100]/100; % solid blue
subCol = [49.3, 70.3, 100]/100; % ice blue

% CREATE SUBMENU
menuFolder = findobj(fig, 'tag', 'plot');
% submenu = uimenu(menuFolder, 'text', 'letswave4eeglab'...
%     ,'separator',0, 'ForegroundColor', titleCol, 'position', 7 ...
%     , 'userdata', 'startup:off;epoch:off;study:on' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MASTER FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uimenu( submenu, 'text', '- MASTER FUNCTION -', 'Separator', 0, ...
%     'userdata' , 'startup:off;continuous:off;epoch:off;study:off;erpset:off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     pop_dusk2dawn
cmd = [ 'pop_letsplot(EEG);' ];
uimenu( menuFolder, 'text', ...
    'Letsplot - Plot data using letswave 7 multiviewer', 'userdata', 'startup:off;epoch:on;study:off', ...
    'callback', cmd, 'Separator', 0, 'ForegroundColor', titleCol);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


