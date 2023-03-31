%
%
%
%
% letswave4eeglab
% Author: Richard Somervail, Istituto Italiano di Tecnologia, 2023
%           www.iannettilab.net
%% 
function pop_letsplot(EEG)


%% convert EEG structure to lwdata structure
lwdata = eeglab2letswave(EEG);
clear EEG % clear from this scope to save memory

%% plot using letswave7 multiviewer

% plot
rs_GLW_multi_viewer_wave(lwdata);


end