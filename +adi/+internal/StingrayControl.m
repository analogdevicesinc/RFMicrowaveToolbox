classdef StingrayControl < adi.common.Attribute
    properties
        PowerUpDown = false
        Ctrl5V = false
        PAOn = false
    end
    
    properties(Hidden)
        SRayCtrlDeviceNames = {'one-bit-adc-dac'};
        SRayCtrlDevices = {};
    end
        
    methods
        function result = get.PowerUpDown(obj)
            result = false;
            if ~isempty(obj.SRayCtrlDevices)
                result = obj.getAttributeRAW('voltage5', 'raw', true, obj.SRayCtrlDevices);
            end
        end
        
        function set.PowerUpDown(obj, value)
            obj.setAttributeRAW('voltage5', 'raw', num2str(value), true, obj.SRayCtrlDevices);
        end
        
        function result = get.Ctrl5V(obj)
            result = false;
            if ~isempty(obj.SRayCtrlDevices)
                result = obj.getAttributeRAW('voltage4', 'raw', true, obj.SRayCtrlDevices);
            end
        end
        
        function set.Ctrl5V(obj, value)
            obj.setAttributeRAW('voltage4', 'raw', num2str(value), true, obj.SRayCtrlDevices);
        end
        
        function result = get.PAOn(obj)
            result = false;
            if ~isempty(obj.SRayCtrlDevices)
                result = obj.getAttributeRAW('voltage0', 'raw', true, obj.SRayCtrlDevices);
            end
        end
        
        function set.PAOn(obj, value)
            obj.setAttributeRAW('voltage0', 'raw', num2str(value), true, obj.SRayCtrlDevices);
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.SRayCtrlDevices = cell(1,length(obj.SRayCtrlDeviceNames));
            for dn = 1:length(obj.SRayCtrlDeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.SRayCtrlDeviceNames{dn},name)
                        obj.SRayCtrlDevices{dn} = devPtr;
                    end
                end
                if isempty(obj.SRayCtrlDevices{dn})
                   error('%s not found',obj.SRayCtrlDeviceNames{dn});
                end
            end
        end
    end
end