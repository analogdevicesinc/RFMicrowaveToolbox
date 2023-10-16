classdef XUD1aControl < adi.common.Attribute & adi.common.Rx
    % ADXUD1AEBZ quad channel Up and Down converter
    %
    % https://wiki.analog.com/resources/eval/user-guides/xud1a/user-guide
    
    properties
        %SelectChannelSetMode SelectChannelSetMode
        %   Select Channel and set Mode
        %   Usage:
        %   Channel A in Tx Mode - Set SelectChannelSetMode to "A_Tx"
        %   Channel A in Rx Low Gain Mode - Set SelectChannelSetMode to "A_RxLG"
        %   Channel A in Rx High Gain Mode - Set SelectChannelSetMode to "A_RxHG"
        %   Channel B in Tx Mode - Set SelectChannelSetMode to "B_Tx"
        %   Channel B in Rx Low Gain Mode - Set SelectChannelSetMode to "B_RxLG"
        %   Channel B in Rx High Gain Mode - Set SelectChannelSetMode to "B_RxHG"
        %   Channel C in Tx Mode - Set SelectChannelSetMode to "C_Tx"
        %   Channel C in Rx Low Gain Mode - Set SelectChannelSetMode to "C_RxLG"
        %   Channel C in Rx High Gain Mode - Set SelectChannelSetMode to "C_RxHG"
        %   Channel D in Tx Mode - Set SelectChannelSetMode to "D_Tx"
        %   Channel D in Rx Low Gain Mode - Set SelectChannelSetMode to "D_RxLG"
        %   Channel D in Rx High Gain Mode - Set SelectChannelSetMode to "D_RxHG"
        SelectChannelSetMode (1,1) string {...
            mustBeMember(SelectChannelSetMode, [...
            "A_Tx", "A_RxLG", "A_RxHG", ...
            "B_Tx", "B_RxLG", "B_RxHG", ...
            "C_Tx", "C_RxLG", "C_RxHG", ...
            "D_Tx", "D_RxLG", "D_RxHG" ...
            ])} = "A_RxLG";
        %PllOutputSel PLL Output Select
        %   Configure ADF4371 output frequency
        %   1: 8-16 GHz
        %   0: 16-32 GHz
        PllOutputSel = 1;
    end

    properties (Hidden)
        %TXRX0 TXRX0
        %   Select Channel A for XUD1A Up and Down converter
        %   Usage:
        %   Channel A in Tx Mode - Set TXRX0 to 0, RxGainMode to 0
        %   Channel A in Rx Low Gain Mode - Set TXRX0 to 1, RxGainMode to 0
        %   Channel A in Rx High Gain Mode - Set TXRX0 to 1, RxGainMode to 1
        TXRX0 = 1;
        %TXRX1 TXRX1
        %   Select Channel B for XUD1A Up and Down converter
        %   Usage:
        %   Channel B in Tx Mode - Set TXRX1 to 0, RxGainMode to 0
        %   Channel B in Rx Low Gain Mode - Set TXRX1 to 1, RxGainMode to 0
        %   Channel B in Rx High Gain Mode - Set TXRX1 to 1, RxGainMode to 1
        TXRX1 = 0;
        %TXRX2 TXRX2
        %   Select Channel C for XUD1A Up and Down converter
        %   Usage:
        %   Channel C in Tx Mode - Set TXRX2 to 0, RxGainMode to 0
        %   Channel C in Rx Low Gain Mode - Set TXRX2 to 1, RxGainMode to 0
        %   Channel C in Rx High Gain Mode - Set TXRX2 to 1, RxGainMode to 1
        TXRX2 = 0;
        %TXRX3 TXRX3
        %   Select Channel D for XUD1A Up and Down converter
        %   Usage:
        %   Channel D in Tx Mode - Set TXRX3 to 0, RxGainMode to 0
        %   Channel D in Rx Low Gain Mode - Set TXRX3 to 1, RxGainMode to 0
        %   Channel D in Rx High Gain Mode - Set TXRX3 to 1, RxGainMode to 1
        TXRX3 = 0;
        %RxGainMode Rx Gain Mode
        %   For usage, see usage of TXRX[0-3]
        RxGainMode = 0;
    end
    
    properties(Hidden)
        XUD1aCtrlDeviceName = 'xud_control';
        XUD1aCtrlDevice
    end
        
    methods
        function set.SelectChannelSetMode(obj, value)
            if obj.ConnectedToDevice
                switch value
                    case "A_Tx"
                        obj.TXRX0 = 0;
                        obj.RxGainMode = 0;
                    case "A_RxLG"
                        obj.TXRX0 = 1;
                        obj.RxGainMode = 0;
                    case "A_RxHG"
                        obj.TXRX0 = 1;
                        obj.RxGainMode = 1;
                    case "B_Tx"
                        obj.TXRX1 = 0;
                        obj.RxGainMode = 0;
                    case "B_RxLG"
                        obj.TXRX1 = 1;
                        obj.RxGainMode = 0;
                    case "B_RxHG"
                        obj.TXRX1 = 1;
                        obj.RxGainMode = 1;
                    case "C_Tx"
                        obj.TXRX2 = 0;
                        obj.RxGainMode = 0;
                    case "C_RxLG"
                        obj.TXRX2 = 1;
                        obj.RxGainMode = 0;
                    case "C_RxHG"
                        obj.TXRX2 = 1;
                        obj.RxGainMode = 1;
                    case "D_Tx"
                        obj.TXRX3 = 0;
                        obj.RxGainMode = 0;
                    case "D_RxLG"
                        obj.TXRX3 = 1;
                        obj.RxGainMode = 0;
                    case "D_RxHG"
                        obj.TXRX3 = 1;
                        obj.RxGainMode = 1;
                end
            end
        end

        function result = get.RxGainMode(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage0', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.RxGainMode(obj, value)
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage0', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
            end
        end
        
        function result = get.TXRX0(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage1', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX0(obj, value)
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage1', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
            end
        end
        
        function result = get.TXRX1(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage2', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX1(obj, value)
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage2', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
            end
        end
        
        function result = get.TXRX2(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage3', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX2(obj, value)
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage3', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
            end
        end
        
        function result = get.TXRX3(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage4', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.TXRX3(obj, value)
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage4', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
            end
        end
        
        function result = get.PllOutputSel(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevice)
                result = obj.getAttributeRAW('voltage5', 'raw', true, obj.XUD1aCtrlDevice);
            end
        end
        
        function set.PllOutputSel(obj, value)
            if obj.ConnectedToDevice
                obj.setAttributeRAW('voltage5', 'raw', num2str(value), true, obj.XUD1aCtrlDevice);
            end
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            obj.XUD1aCtrlDevice = obj.getDev(obj.XUD1aCtrlDeviceName);

            % Set defaults
            obj.setAttributeRAW('voltage1', 'raw', num2str(1), true, obj.XUD1aCtrlDevice);
            obj.setAttributeRAW('voltage0', 'raw', num2str(0), true, obj.XUD1aCtrlDevice);
            obj.setAttributeRAW('voltage5', 'raw', num2str(1), true, obj.XUD1aCtrlDevice);
        end
    end
end