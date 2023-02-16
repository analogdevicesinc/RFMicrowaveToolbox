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
            obj.LTC2314Device = obj.getDev(obj.LTC2314DeviceName);
            if isempty(obj.LTC2314Device)
               error('%s not found',obj.LTC2314DeviceName);
            end
        end
    end
end