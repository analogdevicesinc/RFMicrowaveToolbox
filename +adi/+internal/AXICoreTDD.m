classdef AXICoreTDD < adi.internal.ControlBase & dynamicprops
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

        %EnableSyncSoft Enable Sync Soft
        %   Enable or disable the Sync Soft signal
        EnableSyncSoft = false;
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
                    'type','double',...
                    'attribute','off_ms',...
                    'doc',['%sOffStartMilliseconds %s Off Start in Milliseconds\n',...
                        'This is this time in milliseconds when the channel will \n',...
                        'transition to the Off state. If same as OffStartMilliseconds,\n',...
                        'output will default to Polarity setting.']...
                ),...
                struct('name','OnStartMilliseconds',...
                    'default',0,...
                    'type','double',...
                    'attribute','on_ms',...
                    'doc',['%sOnStartMilliseconds %s On Start in Milliseconds\n',...
                    'This is this time in milliseconds when the channel will \n',...
                    'transition to the On state. If same as OffStartMilliseconds,\n',...
                    'output will default to Polarity setting.']...
                ),...
                struct('name','Enable',...
                    'default',false,...
                    'type','bool',...
                    'attribute','enable',...
                    'doc',['%sEnable %s Enable\n',...
                    'Enable or disable the channel. Will default to Polarity setting']...
                )
            ];

    end
        
    % Get/Set Methods for Device Attributes
    methods

        function v = get.FrameLength(obj)
            if obj.ConnectedToDevice
                v = obj.getDeviceAttributeRAW('frame_length_raw', obj.AXICoreTDDDevice);
            else
                v = NaN;
            end
        end

        function set.Enable(obj, value)
            obj.Enable = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('enable', num2str(value), obj.AXICoreTDDDevice);
            end
        end
        
        
        function set.FrameLengthMilliseconds(obj, value)
            obj.FrameLengthMilliseconds = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('frame_length_ms', ...
                    num2str(value),obj.AXICoreTDDDevice);
                obj.FrameLengthMilliseconds = str2double(...
                    obj.getDeviceAttributeRAW('frame_length_ms', 1024, ...
                    obj.AXICoreTDDDevice));
            end
        end

        function set.EnableSyncSoft(obj, value)
            obj.EnableSyncSoft = value;
            if obj.ConnectedToDevice
                obj.setDeviceAttributeLongLong('sync_soft',int16(value),...
                    obj.AXICoreTDDDevice,false);
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
                frontSpaces = maxPropSize - length(m.Name);
                s = '     '; for sp=1:frontSpaces; s = [s,' ']; end
                value = get(obj, m.Name);
                if ischar(value)
                    s = [s, m.Name, ': ', char("'"), value, char("'")];
                else
                    if numel(value) > 1
                        c = class(value);
                        value = sprintf('%s [%dx%d]',c,size(value,1),size(value,2));
                        s = [s, m.Name, ': ', value];
                    else
                        s = [s, m.Name, ': ', num2str(value)];
                    end
                end
                disp(s);
            end
            fprintf("\n");

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

        function writeProp(obj,Name,value)
            chans = length(obj.channels);
            cChans = length(obj.componentChannels);
            for c = 1:cChans
                comp = obj.componentChannels(c);
                if contains(Name, comp.name)
                    iio_prop = comp.attribute;
                    for nc = 1:chans
                        chan = obj.channels(nc);
                        if contains(Name, chan.name)
                            iio_chan = sprintf('channel%d', chan.channel);
                            if strcmpi(comp.type,'bool')
                                setAttributeBool(obj, iio_chan, iio_prop, ...
                                    value, true, obj.AXICoreTDDDevice);
                            elseif strcmpi(comp.type,'double')
                                setAttributeDouble(obj,iio_chan, iio_prop, ...
                                    value, true, 1, obj.AXICoreTDDDevice);
                            elseif contains(comp.type,'int')
                                setAttributeLongLong(obj, iio_chan, iio_prop, ...
                                    value, true, 10, obj.AXICoreTDDDevice);
                            else
                                error('Unknown prop type %s', comp.type);
                            end
                        end
                    end
                end
            end
        end

        function handlePropEvents(obj, src, ~)
            % Write property into hardware
            if ~obj.ConnectedToDevice
                return;
            end
            value = get(obj,src.Name);
            obj.writeProp(src.Name,value);
        end

        function [valid, d] = stepImpl(~)
            valid = true;
            d = [];
        end


        function setupImpl(obj)
            setupLib(obj);
            initPointers(obj);
            getContext(obj);
            setContextTimeout(obj);
            obj.needsTeardown = true;
            obj.ConnectedToDevice = true;
            setupInit(obj);
        end

        function setupDevicePointers(obj)
            % Handle case where we don't have labels
            obj.AXICoreTDDDevice = iio_context_find_device(obj, ...
                obj.iioCtx, obj.AXICoreTDDDeviceName);
            status = cPtrCheck(obj,obj.AXICoreTDDDevice);
            if status < 0
                obj.AXICoreTDDDevice = getDev(obj, 'adi-iio-fakedev');
            end
        end

        function setupInit(obj)
            obj.setupDevicePointers();
            % Write in all props
            obj.setDeviceAttributeLongLong('enable',obj.Enable,...
                obj.AXICoreTDDDevice,true);
            obj.setDeviceAttributeRAW('frame_length_ms',...
                num2str(obj.FrameLengthMilliseconds),...
                obj.AXICoreTDDDevice,true);
            obj.setDeviceAttributeRAW('startup_delay_ms',...
                num2str(obj.StartupDelayMilliseconds),...
                obj.AXICoreTDDDevice,true);
            chans = length(obj.channels);
            cChans = length(obj.componentChannels);
            for c = 1:cChans
                comp = obj.componentChannels(c);
                iio_prop = comp.attribute;
                for nc = 1:chans
                    chan = obj.channels(nc);
                    iio_chan = sprintf('channel%d', chan.channel);
                    value = get(obj, [chan.name,comp.name]);
                    if strcmpi(comp.type,'bool')
                        setAttributeBool(obj, iio_chan, iio_prop, ...
                            value, true, obj.AXICoreTDDDevice);
                    else
                        setAttributeLongLong(obj, iio_chan, iio_prop, ...
                            value, true, 10, obj.AXICoreTDDDevice);
                    end
                end
            end


        end
    end
end