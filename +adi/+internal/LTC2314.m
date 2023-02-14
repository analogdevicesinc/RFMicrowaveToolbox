classdef LTC2314 < adi.common.Attribute & adi.common.Rx
    properties
        LTC2314RFPower
    end

    properties (Hidden)
        LTC2314Channel = 'voltage0'
    end

    properties (Hidden, Constant)
        ADC_BITS = 14;
    end
    
    properties(Hidden)
        LTC2314DeviceName = 'ltc2314-14'
        LTC2314Device
    end
        
    methods
        function result = get.LTC2314RFPower(obj)
            result = 0;
            if ~isempty(obj.LTC2314Device)
                result = obj.getAttributeRAW('voltage0', 'raw', false, obj.LTC2314Device);
                result = 2.048*str2double(result) / (2^obj.ADC_BITS);
                result = (64.297 * result) - 113;
            end
        end        
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.LTC2314Device = cell(1,length(obj.LTC2314DeviceName));            
            for k = 1:numDevs
                devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                name = obj.iio_device_get_name(devPtr);
                if strcmpi(obj.LTC2314DeviceName,name)
                    obj.LTC2314Device = devPtr;
                end
            end
            if isempty(obj.LTC2314Device)
               error('%s not found',obj.LTC2314DeviceName);
            end
        end
    end
end