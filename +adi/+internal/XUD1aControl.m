classdef XUD1aControl < adi.common.Attribute
    properties
        TXRX0
        TXRX1
        TXRX2
        TXRX3
        PllOutputSel
        RxGainMode
    end
    
    properties(Hidden)
        XUD1aCtrlDeviceNames = {'one-bit-adc-dac'};
        XUD1aCtrlDevices = {};
    end
        
    methods
        function result = get.RxGainMode(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevices)
                result = obj.getAttributeRAW('voltage0', 'raw', true, obj.XUD1aCtrlDevices);
            end
        end
        
        function set.RxGainMode(obj, value)
            obj.setAttributeRAW('voltage0', 'raw', num2str(value), true, obj.XUD1aCtrlDevices);
        end
        
        function result = get.TXRX0(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevices)
                result = obj.getAttributeRAW('voltage1', 'raw', true, obj.XUD1aCtrlDevices);
            end
        end
        
        function set.TXRX0(obj, value)
            obj.setAttributeRAW('voltage1', 'raw', num2str(value), true, obj.XUD1aCtrlDevices);
        end
        
        function result = get.TXRX1(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevices)
                result = obj.getAttributeRAW('voltage2', 'raw', true, obj.XUD1aCtrlDevices);
            end
        end
        
        function set.TXRX1(obj, value)
            obj.setAttributeRAW('voltage2', 'raw', num2str(value), true, obj.XUD1aCtrlDevices);
        end
        
        function result = get.TXRX2(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevices)
                result = obj.getAttributeRAW('voltage3', 'raw', true, obj.XUD1aCtrlDevices);
            end
        end
        
        function set.TXRX2(obj, value)
            obj.setAttributeRAW('voltage3', 'raw', num2str(value), true, obj.XUD1aCtrlDevices);
        end
        
        function result = get.TXRX3(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevices)
                result = obj.getAttributeRAW('voltage4', 'raw', true, obj.XUD1aCtrlDevices);
            end
        end
        
        function set.TXRX3(obj, value)
            obj.setAttributeRAW('voltage4', 'raw', num2str(value), true, obj.XUD1aCtrlDevices);
        end
        
        function result = get.PllOutputSel(obj)
            result = false;
            if ~isempty(obj.XUD1aCtrlDevices)
                result = obj.getAttributeRAW('voltage5', 'raw', true, obj.XUD1aCtrlDevices);
            end
        end
        
        function set.PllOutputSel(obj, value)
            obj.setAttributeRAW('voltage5', 'raw', num2str(value), true, obj.XUD1aCtrlDevices);
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.SRayCtrlDevices = cell(1,length(obj.XUD1aCtrlDeviceNames));
            for dn = 1:length(obj.XUD1aCtrlDeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.XUD1aCtrlDeviceNames{dn},name)
                        obj.SRayCtrlDevices{dn} = devPtr;
                    end
                end
                if isempty(obj.SRayCtrlDevices{dn})
                   error('%s not found',obj.XUD1aCtrlDeviceNames{dn});
                end
            end
        end
    end
end