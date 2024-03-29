classdef AXICorePlutoTDD < adi.common.Attribute & adi.common.Rx
    % AXICorePlutoTDD
    %   TDD Controller for PlutoSDR and Phaser (CN0566) kit
    %
    % Reference https://wiki.analog.com/resources/fpga/docs/axi_tdd

    properties(Dependent) % Read Only
        %CoreID core id
        %   Instance identification number
        %   Read only. Useful for multiple TDD instances
        CoreID
        %State state
        %   The current state of the internal FSM
        %   Read only.  Useful for debugging.
        State
    end

    properties(Dependent)
        %PhaserEnable Enable Phaser Mode on Pluto
        % Sets Phaser Enable bit
        % true = enables the TDD feature to be controlled with external pins
        % false = normal (non TDD) Pluto functionality
        PhaserEnable;
        % Enable Enable TDD
        %   Enable or disable the TDD engine
        Enable
        %BurstCount Burst Count
        %   Configure number of bursts in TDD controller
        %   0 means repeat indefinetly
        BurstCount
        %FrameLength Frame Length
        %   TDD Frame Length (ms)
        FrameLength
        %StartupDelay startup delay ms
        %   Initial delay before the first frame (ms)
        StartupDelay
        %EnSyncExternal sync external
        %   Enable the external sync trigger
        EnSyncExternal
        %SyncReset sync reset
        %   Reset the internal counter when receiving a sync event
        %   Useful to align the beginning of the frame to multiple recurring sync events
        SyncReset
        %SyncSoft sync soft
        %   Trigger the TDD core through a register write. 
        %   This bit self clears.
        SyncSoft

        %Ch0Enable enable
        %   Channel 0 output enable
        Ch0Enable
        %Ch0Polarity polarity
        %   Channel 0 output polarity
        Ch0Polarity
        %Ch0On on ms
        %   The offset from the beggining of a new frame when Channel 0 is set (ms)
        Ch0On
        %Ch0Off off ms
        %   The offset from the beggining of a new frame when Channel 0 is reset (ms)
        Ch0Off

        %Ch1Enable enable
        %   Channel 1 output enable
        %   Channel 1 is connected to the Rx DMA transfer start sync input
        Ch1Enable
        %Ch1Polarity polarity
        %   Channel 1 output polarity
        Ch1Polarity
        %Ch1On on ms
        %   The offset from the beggining of a new frame when Channel 1 is set (ms)
        %   Channel 1 is connected to the Rx DMA transfer start sync input
        Ch1On
        %Ch1Off off ms
        %   The offset from the beggining of a new frame when Channel 1 is reset (ms)
        %   Channel 1 is connected to the Rx DMA transfer start sync input
        Ch1Off

        %Ch2Enable enable
        %   Channel 2 output enable
        %   Channel 2 is connected to the Tx packer reset
        Ch2Enable
        %Ch2Polarity polarity
        %   Channel 2 output polarity
        Ch2Polarity
        %Ch2On on ms
        %   The offset from the beggining of a new frame when Channel 2 is set (ms)
        Ch2On 
        %Ch2Off off ms
        %   The offset from the beggining of a new frame when Channel 2 is reset (ms)
        Ch2Off
    end
    
    properties(Hidden)
        AXICoreTDDDevPtrName = 'adi-iio-fakedev';
        AXICoreTDDDevPtr
        GPIODevIIO
    end
        
    % Get/Set Methods for Device Attributes
    methods
        function result = get.PhaserEnable(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = obj.getAttributeBool('voltage0', 'raw', true, obj.GPIODevIIO);
            end
        end
        function set.PhaserEnable(obj, value)
            if obj.ConnectedToDevice
                setAttributeBool(obj, 'voltage0', 'raw', value, true, obj.GPIODevIIO);
            end
        end

        function result = get.BurstCount(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('burst_count', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.BurstCount(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('burst_count', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.CoreID(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('core_id', 128, obj.AXICoreTDDDevPtr));
            end
        end
                       
        function result = get.Enable(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('enable', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Enable(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('enable', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.FrameLength(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('frame_length_ms', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.FrameLength(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('frame_length_ms', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.StartupDelay(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('startup_delay_ms', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.StartupDelay(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('startup_delay_ms', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.State(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('state', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function result = get.EnSyncExternal(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('sync_external', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.EnSyncExternal(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sync_external', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.SyncReset(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getDeviceAttributeRAW('sync_reset', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.SyncReset(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sync_reset', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
       
        function set.SyncSoft(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sync_soft', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
    end
    

    % Get/Set Methods for Channel Attributes
    methods
        function result = get.Ch0Enable(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel0', 'enable', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch0Enable(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch0Enable');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel0', 'enable', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.Ch0Polarity(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel0', 'polarity', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch0Polarity(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch0Polarity');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel0', 'polarity', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch0On(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel0', 'on_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch0On(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch0On');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel0', 'on_ms', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch0Off(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel0', 'off_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch0Off(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch0Off');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel0', 'off_ms', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch1Enable(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel1', 'enable', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch1Enable(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch1Enable');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel1', 'enable', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.Ch1Polarity(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel1', 'polarity', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch1Polarity(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch1Polarity');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel1', 'polarity', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch1On(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel1', 'on_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch1On(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch1On');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel1', 'on_ms', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch1Off(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel1', 'off_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch1Off(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch1Off');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel1', 'off_ms', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch2Enable(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel2', 'enable', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch2Enable(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch2Enable');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel2', 'enable', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.Ch2Polarity(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel2', 'polarity', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch2Polarity(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch2Polarity');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel2', 'polarity', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch2On(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel2', 'on_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch2On(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch2On');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel2', 'on_ms', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end

        function result = get.Ch2Off(obj)
            result = nan;
            if obj.ConnectedToDevice
                result = str2double(obj.getAttributeRAW('channel2', 'off_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Ch2Off(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'nonnegative'}, 'Ch2Off');
            if obj.ConnectedToDevice
                obj.setAttributeRAW('channel2', 'off_ms', num2str(value), true, obj.AXICoreTDDDevPtr);
            end
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            obj.GPIODevIIO = obj.getDev('one-bit-adc-dac');
            obj.AXICoreTDDDevPtr = obj.getDev(obj.AXICoreTDDDevPtrName);
        end
    end
end