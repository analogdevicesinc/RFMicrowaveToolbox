classdef AXICoreTDD < adi.common.Attribute & adi.common.Rx
    % AXICoreTDD
    %
    % Reference https://wiki.analog.com/resources/fpga/docs/axi_tdd

    properties
        %BurstCount Burst Count
        %   Configure number of bursts in TDD controller
        BurstCount
        %CounterInt Counter Int
        %   Configure TDD internal counter start value
        CounterInt
        %DMAGateingMode DMA Gateing Mode
        %   Configure TDD DMA gate
        %   - none
        %   - rx_only
        %   - tx_only
        %   - rx_tx
        DMAGateingMode = 'none';
        % Enable Enable TDD
        %   Enable or disable the TDD engine
        Enable
        %EnableMode Enable Mode
        %   Configure TDD controller RX/TX mode. Options are:
        %   - rx_only
        %   - tx_only
        %   - rx_tx
        EnableMode = 'rx_only';
        %FrameLength Frame Length
        %   TDD Frame Length
        FrameLength
        %Secondary Secondary
        %   Enable secondary times. Allows one signal to go high
        %   twice at two times within a single frame.
        Secondary
        %SyncTerminalType Sync Terminal Type
        %   Sync Terminal Type
        SyncTerminalType
        
        %TxDPoff Tx DP Off (ms)
        %   TDD: TX DMA port timing parameters in ms.
        %   Format [primary_off secondary_off]
        TxDPoff = [0 0];
        %TxDPon Tx DP On (ms)
        %   TDD: TX DMA port timing parameters in ms.
        %   Format [primary_on secondary_on]
        TxDPon = [0 0];
        %TxOff Tx Off (ms)
        %   TDD: TX RF port timing parameters in ms.
        %   Format [primary_off secondary_off]
        TxOff = [0 0];
        %TxOn Tx Off (ms)
        %   TDD: TX RF port timing parameters in ms.
        %   Format [primary_on secondary_on]
        TxOn = [0 0];
        %TxVCOoff Tx VCO Off (ms)
        %   TDD: TX VCO port timing parameters in ms.
        %   Format [primary_off secondary_off]
        TxVCOoff = [0 0];
        %TxVCOon Tx VCO On (ms)
        %   TDD: TX VCO port timing parameters in ms.
        %   Format [primary_on secondary_on]
        TxVCOon = [0 0];
        %RxDPoff Rx DP Off (ms)
        %   TDD: RX DMA port timing parameters in ms.
        %   Format [primary_off secondary_off]
        RxDPoff = [0 0];
        %RxDPon Rx DP On (ms)
        %   TDD: RX DMA port timing parameters in ms.
        %   Format [primary_on secondary_on]
        RxDPon = [0 0];
        %RxOff Rx Off (ms)
        %   TDD: RX RF port timing parameters in ms.
        %   Format [primary_off secondary_off]
        RxOff = [0 0];
        %RxOn Rx On (ms) 
        %   TDD: RX RF port timing parameters in ms.
        %   Format [primary_on secondary_on]
        RxOn = [0 0];
        %RxVCOoff Rx VCO Off (ms) 
        %   TDD: RX VCO port timing parameters in ms.
        %   Format [primary_off secondary_off]
        RxVCOoff = [0 0];
        %RxVCOon Rx VCO On (ms)
        %   TDD: RX VCO port timing parameters in ms.
        %   Format [primary_on secondary_on]
        RxVCOon = [0 0];
    end
    
    properties(Hidden)
        AXICoreTDDDevPtrNames = {'axi-core-tdd'};
        AXICoreTDDDevPtr
    end
        
    properties(Constant, Hidden)
        EnableModeSet = matlab.system.StringSet({ ...
            'rx_only', 'tx_only', 'rx_tx'});
        DMAGateingModeSet = matlab.system.StringSet({ ...
            'none','rx_only', 'tx_only', 'rx_tx'});
    end
    % Get/Set Methods for Device Attributes
    methods
        function result = get.BurstCount(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = str2double(obj.getDeviceAttributeRAW('burst_count', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.BurstCount(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('burst_count', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.CounterInt(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = str2double(obj.getDeviceAttributeRAW('counter_int', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.CounterInt(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('counter_int', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.DMAGateingMode(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = obj.getDeviceAttributeRAW('dma_gateing_mode', 128, obj.AXICoreTDDDevPtr);
            end
        end
        
        function set.DMAGateingMode(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('dma_gateing_mode', value, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.Enable(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = str2double(obj.getDeviceAttributeRAW('en', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Enable(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('en', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.EnableMode(obj)
            result = nan;
            if obj.ConnectedToDevice
                result= obj.getDeviceAttributeRAW('en_mode', 128, obj.AXICoreTDDDevPtr);
            end
        end
        
        function set.EnableMode(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('en_mode', value, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.FrameLength(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = str2double(obj.getDeviceAttributeRAW('frame_length_ms', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.FrameLength(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('frame_length_ms', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.Secondary(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = str2double(obj.getDeviceAttributeRAW('secondary', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.Secondary(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('secondary', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.SyncTerminalType(obj)
            result = nan;
            if ~isempty(obj.AXICoreTDDDevPtr)
                result = str2double(obj.getDeviceAttributeRAW('sync_terminal_type', 128, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.SyncTerminalType(obj, value)
            if obj.ConnectedToDevice
                obj.setDeviceAttributeRAW('sync_terminal_type', num2str(value), obj.AXICoreTDDDevPtr);
            end
        end
    end
    
    % Get/Set Methods for Channel Attributes
    methods
        function result = get.TxDPoff(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'dp_off_ms', true, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'dp_off_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.TxDPoff(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'dp_off_ms', num2str(value(1)), true, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'dp_off_ms', num2str(value(2)), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.TxDPon(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'dp_on_ms', true, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'dp_on_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.TxDPon(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'dp_on_ms', num2str(value(1)), true, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'dp_on_ms', num2str(value(2)), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.TxOff(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'off_ms', true, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'off_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.TxOff(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'off_ms', num2str(value(1)), true, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'off_ms', num2str(value(2)), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.TxOn(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'on_ms', true, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'on_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.TxOn(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'on_ms', num2str(value(1)), true, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'on_ms', num2str(value(2)), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.TxVCOoff(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'vco_off_ms', true, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'vco_off_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.TxVCOoff(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'vco_off_ms', num2str(value(1)), true, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'vco_off_ms', num2str(value(2)), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.TxVCOon(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'vco_on_ms', true, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'vco_on_ms', true, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.TxVCOon(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'vco_on_ms', num2str(value(1)), true, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'vco_on_ms', num2str(value(2)), true, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.RxDPoff(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'dp_off_ms', false, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'dp_off_ms', false, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.RxDPoff(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'dp_off_ms', num2str(value(1)), false, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'dp_off_ms', num2str(value(2)), false, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.RxDPon(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'dp_on_ms', false, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'dp_on_ms', false, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.RxDPon(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'dp_on_ms', num2str(value(1)), false, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'dp_on_ms', num2str(value(2)), false, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.RxOff(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'off_ms', false, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'off_ms', false, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.RxOff(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'off_ms', num2str(value(1)), false, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'off_ms', num2str(value(2)), false, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.RxOn(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'on_ms', false, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'on_ms', false, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.RxOn(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'on_ms', num2str(value(1)), false, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'on_ms', num2str(value(2)), false, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.RxVCOoff(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'vco_off_ms', false, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'vco_off_ms', false, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.RxVCOoff(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'vco_off_ms', num2str(value(1)), false, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'vco_off_ms', num2str(value(2)), false, obj.AXICoreTDDDevPtr);
            end
        end
        
        function result = get.RxVCOon(obj)
            result = [nan nan];
            if ~isempty(obj.AXICoreTDDDevPtr)
                result(1) = str2double(obj.getAttributeRAW('data0', 'vco_on_ms', false, obj.AXICoreTDDDevPtr));
                result(2) = str2double(obj.getAttributeRAW('data1', 'vco_on_ms', false, obj.AXICoreTDDDevPtr));
            end
        end
        
        function set.RxVCOon(obj, value)
            validateattributes(value, {'double', 'single', 'uint32'}, {'size', [1 2]});
            if obj.ConnectedToDevice
                obj.setAttributeRAW('data0', 'vco_on_ms', num2str(value(1)), false, obj.AXICoreTDDDevPtr);
                obj.setAttributeRAW('data1', 'vco_on_ms', num2str(value(2)), false, obj.AXICoreTDDDevPtr);
            end
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            for dn = 1:length(obj.AXICoreTDDDevPtrNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.AXICoreTDDDevPtrNames{dn},name)
                        obj.AXICoreTDDDevPtr = devPtr;
                    end
                end
                if isempty(obj.AXICoreTDDDevPtr)
                   error('%s not found',obj.AXICoreTDDDevPtrNames{dn});
                end
            end
        end
    end
end