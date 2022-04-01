classdef ADF4371 < adi.common.Attribute & adi.common.Rx
    properties
        MUXOutEnable
        % MUXOutMode
        Name
        ADF4371Frequency
        Phase
        PowerDown
        ADF4371Temp
    end
    
    properties(Hidden)
        ADF4371DevicePtr = {};
    end
        
    methods
        function result = get.MUXOutEnable(obj)
            result = false;
            if ~isempty(obj.ADF4371DevicePtr)
                result = logical(str2double(obj.getDeviceAttributeRAW('muxout_enable', 128, obj.ADF4371DevicePtr)));
            end
        end
        
        function set.MUXOutEnable(obj, value)
            obj.setDeviceAttributeRAW('muxout_enable', num2str(value), obj.ADF4371DevicePtr);
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            obj.ADF4371DevicePtr = getDev(obj, 'adf4371-0');
        end
    end
end