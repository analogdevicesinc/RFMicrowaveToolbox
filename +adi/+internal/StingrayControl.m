classdef StingrayControl < adi.common.Attribute
    % Power tree for ADAR1000-EVAL1Z board
    %
    % See: https://wiki.analog.com/resources/eval/user-guides/stingray/userguide#board_power_control

    properties
        %PowerUpDown Power Control
        %   Pulse to sequence the first RF power rails
        %   in ADAR1000-EVAL1Z board power tree
        PowerUpDown = false
        %Ctrl5V Control 5V
        %   Pulse +5V in ADAR1000-EVAL1Z board power tree
        Ctrl5V = false
        %PAOn PA On/Off
        %   Enable/disable PA
        %   in ADAR1000-EVAL1Z board power tree
        PAOn = false
    end
    
    properties(Hidden)
        SRayCtrlDeviceName = 'stingray_control';
        SRayCtrlDevice
    end
        
    methods
        function result = get.PowerUpDown(obj)
            result = false;
            if ~isempty(obj.SRayCtrlDevice)
                result = obj.getAttributeRAW('voltage5', 'raw', true, obj.SRayCtrlDevice);
            end
        end
        
        function set.PowerUpDown(obj, value)
            obj.setAttributeRAW('voltage5', 'raw', num2str(value), true, obj.SRayCtrlDevice);
        end
        
        function result = get.Ctrl5V(obj)
            result = false;
            if ~isempty(obj.SRayCtrlDevice)
                result = obj.getAttributeRAW('voltage4', 'raw', true, obj.SRayCtrlDevice);
            end
        end
        
        function set.Ctrl5V(obj, value)
            obj.setAttributeRAW('voltage4', 'raw', num2str(value), true, obj.SRayCtrlDevice);
        end
        
        function result = get.PAOn(obj)
            result = false;
            if ~isempty(obj.SRayCtrlDevice)
                result = obj.getAttributeRAW('voltage0', 'raw', true, obj.SRayCtrlDevice);
            end
        end
        
        function set.PAOn(obj, value)
            obj.setAttributeRAW('voltage0', 'raw', num2str(value), true, obj.SRayCtrlDevice);
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            obj.SRayCtrlDevice = obj.getDev(obj.SRayCtrlDeviceName);
            if isempty(obj.SRayCtrlDevice)
               error('%s not found',obj.SRayCtrlDeviceName);
            end
        end
    end
end