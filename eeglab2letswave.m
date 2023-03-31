% 
% 
%   converts eeglab structure to letswave structure 
% 
%       ! currently only handles time domain data
% 
% letswave4eeglab
% Author: Richard Somervail, Istituto Italiano di Tecnologia, 2023
%           www.iannettilab.net
function lwdata = eeglab2letswave(EEG)

%% loop through datasets
for f = 1:length(EEG)

    %% format actual data correctly
    lwdata(f).data = permute(single(EEG(f).data),[3,1,4,5,6,2]);
    
    %% format header
    lwdata(f).header=[];
    lwdata(f).header.filetype='time_amplitude';
    if ~isempty(EEG(f).setname)
        lwdata(f).header.name = EEG(f).setname;
    elseif ~isempty(EEG(f).filename)
        lwdata(f).header.name = EEG(f).filename;
    else
        lwdata(f).header.name = 'error _ dataset name not found';
    end
    lwdata(f).header.tags='';
    lwdata(f).header.datasize=[EEG(f).trials EEG(f).nbchan 1 1 1 EEG(f).pnts];
    lwdata(f).header.xstart=EEG(f).times(1);
    lwdata(f).header.ystart=0;
    lwdata(f).header.zstart=0;
    lwdata(f).header.xstep=1/EEG(f).srate;
    lwdata(f).header.ystep=1;
    lwdata(f).header.zstep=1;
    lwdata(f).header.history=[];
    lwdata(f).header.source = EEG(f).filepath;
    
    chanloc.labels='';
    chanloc.topo_enabled=0;
    chanloc.SEEG_enabled=0;
    for chanpos = 1:EEG(f).nbchan
        chanloc.labels = EEG(f).chanlocs(chanpos).labels;
        lwdata(f).header.chanlocs(chanpos) = chanloc;
    end
    
    % ? skipping event plotting for now because not needed for multiviewer plot
    % 
    % numevents=size(trg,2);
    % if numevents==0
    %     lwdata(f).header.events=[];
    % else
    %     k=0;
    %     for eventpos=1:numevents
    %         event.code='unknown';
    %         if strcmpi('.set',ext)
    %             if isempty(trg(eventpos).value)
    %                 event.code=trg(eventpos).type;
    %             else
    %                 event.code=trg(eventpos).value;
    %             end
    %             if isnumeric(event.code)
    %                 event.code=num2str(event.code);
    %             end
    %             if(lwdata(f)_out.header.datasize(1)==1) %if it is continous data or just a single epoch
    %                 event.latency=(trg(eventpos).sample*lwdata(f)_out.header.xstep)+lwdata(f)_out.header.xstart;
    %                 event.epoch=1;
    %             else %if it is an epoched dataset
    %                 if isempty(trg(eventpos).epoch)
    %                     continue;
    %                 end
    %                 event.epoch = floor(trg(eventpos).sample/lwdata(f)_out.header.datasize(6))+1;
    %                 event.latency=((trg(eventpos).sample*lwdata(f)_out.header.xstep)+lwdata(f)_out.header.xstart)-...
    %                     (event.epoch-1)*lwdata(f)_out.header.xstep*lwdata(f)_out.header.datasize(6);
    %             end
    %         else
    %             if isempty(trg(eventpos).value)
    %                 event.code=trg(eventpos).type;
    %             else
    %                 event.code=trg(eventpos).value;
    %             end
    %             if isnumeric(event.code)
    %                 event.code=num2str(event.code);
    %             end
    %             event.latency=(trg(eventpos).sample*lwdata(f)_out.header.xstep)+lwdata(f)_out.header.xstart;
    %             event.epoch=1;
    %         end
    %         k=k+1;
    %         lwdata(f)_out.header.events(k)=event;
    %     end
    % end

end % dataset loop

end