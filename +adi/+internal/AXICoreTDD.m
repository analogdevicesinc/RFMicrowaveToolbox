classdef AXICoreTDD < adi.common.Attribute & adi.common.Rx & dynamicprops
    % AXICoreTDD Internal Class
    %   This class contains properties and methods to be used for child TDD
    %   implementations and share device attributes. Since channels are
    %   specific to the end-configuration, they must be defined in the
    %   child classes.
    %
    % Reference https://wiki.analog.com/resources/fpga/docs/axi_tdd

    properties(Logical)
        % Enable Enable TDD
        %   Enable or disable the TDD engine
        Enable = false;
    end

    properties
        %FrameLengthMilliseconds Frame Length in Milliseconds
        %   TDD Frame Length in Milliseconds. 
        FrameLengthMilliseconds = 1;

        %StartupDelayMilliseconds Startup Delay in Milliseconds
        %   TDD Startup Delay in Milliseconds for all channels.
        StartupDelayMilliseconds = 0;
    end

    properties(Dependent)
        %FrameLength Frame Length
        %   TDD Frame Length in samples. Note this is a read-only property
        %   Change FrameLengthMilliseconds to change this value.
        FrameLength;
    end
    
    properties(Abstract, Hidden)
        channels;
    end

    properties(Hidden)
        AXICoreTDDDeviceName = 'axi-core-tdd';
        AXICoreTDDDevice
    end

    properties(Constant, Hidden)
            componentChannels = [...
                struct('name','Polarity',...
                    'default',false,...
                    'type','bool',...
                    'attribute','polarity',...
                    'doc',['%sPolarity %s Polarity\n',...
                    'Enable signal inversion. When true On is low, Off is high.\n',...
                    'When false On is high, Off is low.']...
                ),...
                struct('name','OffStartMilliseconds',...
                    'default',0,...
                    'type','int16',...
                    'attribute','off_ms',...
                    'doc',['%sOffStartMilliseconds %s Off Start in Milliseconds\n',...
                        'This is this time in milliseconds when the channel will \n',...
                        'transition to the Off state. If same as OffStartMilliseconds,\n',...
                        'output will default to Polarity setting.']...
                ),...
                struct('name','OnStartMilliseconds',...
                    'default',0,...
                    'type','int16',...
                    'attribute','on_ms',...
                    'doc',['%sOnStartMilliseconds %s On Start in Milliseconds\n',...
                    'This is this time in milliseconds when the channel will \n',...
                    'transition to the On state. If same as OffStartMilliseconds,\n',...
                    'output will default to Polarity setting.']...
                ),...
                struct('name','Enable',...
                    'default',false,...
                    'type','bool',...
                    'attribute','en',...
                    'doc',['%sEnable %s Enable\n',...
                    'Enable or disable the channel. Will default to Polarity setting']...
                )
            ];

    end
        
    % Get/Set Methods for Device Attributes
    methods

        function v = get.FrameLength(obj)
            if obj.ConnectedToDevice
                % v = getAttribute(obj, '')
                v = NaN;
            else
                v = NaN;
            end
        end

        function set.Enable(obj, value)
            obj.Enable = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('en', num2str(value), obj.AXICoreTDDDevice);
            end
        end
        
        
        function set.FrameLengthMilliseconds(obj, value)
            % Verify integer and less than 2^16
            if ~(isnumeric(value) && mod(value,1) == 0 && value < 2^16)
                error('FrameLength must be an integer less than 2^16');
            end
            obj.FrameLengthMilliseconds = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('frame_length_ms', num2str(value), obj.AXICoreTDDDevice);
            end
        end
        

    end

    methods (Hidden, Access = protected)
        

        function displayScalarObject(obj)
            %% Enhance display to show dynamically generated properties
            className = matlab.mixin.CustomDisplay.getClassNameForHeader(obj);
            fprintf('  %s with properties\n\n',className);
            allprops = properties(obj);
            maxPropSize = 0;
            names = {};
            for i=1:numel(allprops)
                m = findprop(obj,allprops{i});
                ml = length(m.Name);
                if ml > maxPropSize
                    maxPropSize = ml;
                end
                names = [names(:)', {m.Name}];
            end
            names = sort(names);
            % Print
            for i=1:numel(names)
                m = findprop(obj,names{i});
                if strcmpi(m.Name,'EnabledChannels') || ...
                    strcmpi(m.Name, 'enIO')
                    continue;
                end
                value = get(obj, m.Name);
                frontSpaces = maxPropSize - length(m.Name);
                s = '     '; for sp=1:frontSpaces; s = [s,' ']; end
                if ischar(value)
                    s = [s, m.Name, ': ', char("'"), value, char("'")];
                else
                    s = [s, m.Name, ': ', num2str(value)];
                end
                disp(s);
            end

        end

        function buildChannels(obj)
            numChannels = length(obj.channels);
            numComponentChannels = length(obj.componentChannels);
                
            for numChan = 1:numChannels
                chan = obj.channels(numChan);
                for numCompChan = 1:numComponentChannels
                    compChan = obj.componentChannels(numCompChan);
                    propName = [chan.name, compChan.name];
                    % disp(propName);
                    doc = sprintf(compChan.doc,chan.name,chan.name);
                    % Add property
                    obj.addprop(propName);
                    % Make observable so we can share a setter method
                    m = findprop(obj,propName);
                    m.SetObservable = true;
                    m.Description = doc;
                    m.Transient = true;
                    set(obj,propName,compChan.default)
                    addlistener(obj,propName,'PostSet',@obj.handlePropEvents);
                end
            end
        end

        function handlePropEvents(obj, src, ~)
            % Write property into hardware
            if ~obj.ConnectedToDevice
                return;
            end
            value = get(obj,src.Name);
            chans = length(obj.channels);
            cChans = length(obj.componentChannels);
            for c = 1:cChans
                comp = obj.componentChannels(c);
                if contains(src.Name, comp.name)
                    iio_prop = comp.attribute;
                    for nc = 1:chans
                        chan = obj.channels(nc);
                        if contains(src.Name, chan.name)
                            iio_chan = sprintf('voltage%d', chan.channel);
                            if strcmpi(comp.type,'bool')
                                setAttributeBool(obj, iio_chan, iio_prop, ...
                                    value, true, obj.AXICoreTDDDevice);
                            else
                                setAttributeLongLong(obj, iio_chan, iio_prop, ...
                                    value, true, obj.AXICoreTDDDevice);
                            end
                        end
                    end
                end
            end
        end

        function setupInit(obj)
            obj.AXICoreTDDDevice = obj.getDev(obj.AXICoreTDDDeviceName);
            if isempty(obj.AXICoreTDDDevice)
               error('%s not found',obj.AXICoreTDDDeviceName);
            end
        end
    end
end