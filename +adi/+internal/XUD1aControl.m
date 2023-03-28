classdef XUD1aControl < adi.common.Attribute
    % ADXUD1AEBZ quad channel Up and Down converter
    %
    % https://wiki.analog.com/resources/eval/user-guides/xud1a/user-guide
    
    properties
        %TXRX0 TXRX0
        %   Select Channel A for XUD1A Up and Down converter
        %   Usage:
        %   Channel A in Tx Mode - Set TXRX0 to 0, RxGainMode to 0
        %   Channel A in Rx Low Gain Mode - Set TXRX0 to 1, RxGainMode to 0
        %   Channel A in Rx High Gain Mode - Set TXRX0 to 1, RxGainMode to 1
        TXRX0
        %TXRX1 TXRX1
        %   Select Channel B for XUD1A Up and Down converter
        %   Usage:
        %   Channel B in Tx Mode - Set TXRX1 to 0, RxGainMode to 0
        %   Channel B in Rx Low Gain Mode - Set TXRX1 to 1, RxGainMode to 0
        %   Channel B in Rx High Gain Mode - Set TXRX1 to 1, RxGainMode to 1
        TXRX1
        %TXRX2 TXRX2
        %   Select Channel C for XUD1A Up and Down converter
        %   Usage:
        %   Channel C in Tx Mode - Set TXRX2 to 0, RxGainMode to 0
        %   Channel C in Rx Low Gain Mode - Set TXRX2 to 1, RxGainMode to 0
        %   Channel C in Rx High Gain Mode - Set TXRX2 to 1, RxGainMode to 1
        TXRX2
        %TXRX3 TXRX3
        %   Select Channel D for XUD1A Up and Down converter
        %   Usage:
        %   Channel D in Tx Mode - Set TXRX3 to 0, RxGainMode to 0
        %   Channel D in Rx Low Gain Mode - Set TXRX3 to 1, RxGainMode to 0
        %   Channel D in Rx High Gain Mode - Set TXRX3 to 1, RxGainMode to 1
        TXRX3
        %PllOutputSel PLL Output Select
        %   Configure ADF4371 output frequency
        %   1: 8-16 GHz
        %   0: 16-32 GHz
        PllOutputSel
        %RxGainMode Rx Gain Mode
        %   For usage, see usage of TXRX[0-3]
        RxGainMode
    end
    
    properties(Hidden)
        XUD1aCtrlDeviceName = 'xud_control';
        XUD1aCtrlDevice
    end
        
    methods
        function result = get.RxGainMode(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage0', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.RxGainMode(obj, value)
            obj.setAttributeRAW('voltage0', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
        end
        
        function result = get.TXRX0(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage1', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX0(obj, value)
            obj.setAttributeRAW('voltage1', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
        end
        
        function result = get.TXRX1(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage2', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX1(obj, value)
            obj.setAttributeRAW('voltage2', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
        end
        
        function result = get.TXRX2(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage3', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX2(obj, value)
            obj.setAttributeRAW('voltage3', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
        end
        
        function result = get.TXRX3(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage4', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX3(obj, value)
            obj.setAttributeRAW('voltage4', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
        end
        
        function result = get.PllOutputSel(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage5', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.PllOutputSel(obj, value)
            obj.setAttributeRAW('voltage5', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            obj.XUD1aCtrlDevice = obj.getDev(obj.XUD1aCtrlDeviceName);
            if isempty(obj.XUD1aCtrlDevice)
               error('%s not found',obj.XUD1aCtrlDeviceName);
            end
        end
    end
end