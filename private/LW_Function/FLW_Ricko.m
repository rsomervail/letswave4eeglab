classdef FLW_Ricko<CLW_generic
    properties
        FLW_TYPE=1;
        h_ampcrit; % amplitude criterion for interpolation
        h_critunits_pop; % popup box of absolute amplitude vs stdevs
    end
    
    methods
        function obj = FLW_Ricko(batch_handle)
            obj@CLW_generic(batch_handle,'autoint','autoint',... 
                'Experimental function, not currently useful - Rick S.');
            % GUI settings -------------------
            % amplitude criterion 
            uicontrol('style','text','position',[30,430,200,20],...
                'string','amplitude criterion',...
                'HorizontalAlignment','left','parent',obj.h_panel);
            obj.h_ampcrit=uicontrol('style','edit',...
                'position',[30,400,100,30],'HorizontalAlignment','left',...
                'string','0','parent',obj.h_panel,'callback',@obj.item_start_changed);
            % criterion units           
            uicontrol('style','text','position',[150,430,200,20],...
                'string','criterion units','HorizontalAlignment','left',...
                'parent',obj.h_panel);
            obj.h_critunits_pop=uicontrol('style','popupmenu',...
                'String',{'raw amplitude','stdev across epochs'},'value',1,'backgroundcolor',[1,1,1],...
                'position',[150,400,200,30],'parent',obj.h_panel);
            

        end
        
        function option=get_option(obj)
            option=get_option@CLW_generic(obj);
            
            str=get(obj.h_critunits_pop,'String');
            str_value=get(obj.h_critunits_pop,'value');
            option.h_critunits_pop=str{str_value};
            
            option.h_ampcrit=str2double(get(obj.h_ampcrit,'string')); % RS           
%             option.x_start=str2double(get(obj.h_ampcrit,'string')); % RS
%             option.x_end   =str2double(get(obj.h_ampcrit,'string')); % RS
        end
        
        function set_option(obj,option)
            set_option@CLW_generic(obj,option);
%             switch option.h_critunits_pop
%                 case 'raw amplitude'
%                     set(obj.h_critunits_pop,'value',1);
%                 case 'stdev across epochs'
%                     set(obj.h_critunits_pop,'value',2);
%             end

        end
        
        function str=get_Script(obj)
            option=get_option(obj);
            frag_code=[];
            frag_code=[frag_code,'''amplitude criterion'',''',...
                num2str(option.h_ampcrit),''','];
            frag_code=[frag_code,'''criterion units'',',...
                option.h_critunits_pop,','];
            str=get_Script@CLW_generic(obj,frag_code,option);
        end
    end
    
    methods (Static = true)
        function header_out= get_header(header_in,option)
            if ~strcmpi(header_in.filetype,'time_amplitude')
                warning('!!! WARNING : input data is not of format time_amplitude!');
            end
            header_out=header_in;
           
            %! do stuff to header            
            
            if ~isempty(option.suffix)
                header_out.name=[option.suffix,' ',header_out.name];
            end
            option.function=mfilename;
            header_out.history(end+1).option=option;
            
        end
        
        function lwdata_out=get_lwdata(lwdata_in,varargin)
            
%             option.suffix='autoint';
            option.is_save=0;
            option=CLW_check_input(option,{'h_ampcrit','h_critunits_pop',...
                'suffix','is_save'},varargin);
            header=FLW_Ricko.get_header(lwdata_in.header,option);
            option=header.history(end).option;
            
            data = lwdata_in.data;
            
            % get standard deviation across epochs if needed
%             if option.
            
            
            
            lwdata_out.header=header;
            lwdata_out.data=data;
            if option.is_save
                CLW_save(lwdata_out);
            end
        end
    end
end