classdef ADF4371 < adi.common.Attribute & adi.common.Rx
    properties
        ADF4371Name = 'RF8x'
        ADF4371Frequency = 5000000000
        ADF4371Phase = 359999
        MUXOutEnable = true
    end

    properties (Hidden)
        ADF4371Channel = 'altvoltage0'
    end
    
    properties(Hidden)
        ADF4371DeviceName = 'adf4371-0'
        ADF4371Device
    end
        
    methods
        function set.ADF4371Name(obj, value)
            obj.ADF4371Name = value;
            if obj.ConnectedToDevice                
                switch value
                    case 'RF8x'
                        setAttributeBool(obj,'altvoltage0','powerdown',true,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage1','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage3','powerdown',false,true,obj.ADF4371Device);
                        obj.ADF4371Channel = 'altvoltage0';
                    case 'RFAUX8x'
                        setAttributeBool(obj,'altvoltage0','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage1','powerdown',true,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage3','powerdown',false,true,obj.ADF4371Device);
                        obj.ADF4371Channel = 'altvoltage1';
                    case 'RF16x'
                        setAttributeBool(obj,'altvoltage0','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage1','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage2','powerdown',true,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage3','powerdown',false,true,obj.ADF4371Device);
                        obj.ADF4371Channel = 'altvoltage2';
                    case 'RF32x'
                        setAttributeBool(obj,'altvoltage0','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage1','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device);
                        setAttributeBool(obj,'altvoltage3','powerdown',true,true,obj.ADF4371Device);
                        obj.ADF4371Channel = 'altvoltage3';
                    otherwise
                        error('Invalid setting chosen for ADF4371Name');
                end
            end
        end

        function set.ADF4371Frequency(obj, value)
            switch obj.ADF4371Name
                case {'RF8x', 'RFAUX8x'}
                    validateattributes( obj.ADF4371Frequency,{ 'double','single', 'uint32' }, ...
                        { 'real', 'nonnegative','scalar','finite', 'nonnan', 'nonempty','integer',...
                        '>=',4000000000,'<=',8000000000},'', 'ADF4371Frequency');
                case 'RF16x'
                    validateattributes( obj.ADF4371Frequency,{ 'double','single', 'uint32' }, ...
                        { 'real', 'nonnegative','scalar','finite','nonnan', 'nonempty','integer',...
                        '>=',8000000000,'<=',16000000000},'', 'ADF4371Frequency');
                case 'RF32x'
                    validateattributes( obj.ADF4371Frequency,{ 'double','single', 'uint32' }, ...
                        { 'real', 'nonnegative','scalar','finite','nonnan', 'nonempty','integer',...
                        '>=',16000000000,'<=',32000000000},'', 'ADF4371Frequency');
            end
            obj.ADF4371Frequency = value;
            if obj.ConnectedToDevice
                setAttributeLongLong(obj,obj.ADF4371Channel,'frequency',value,true,0,obj.ADF4371Device);
            end
        end

        function set.ADF4371Phase(obj, value)
            validateattributes( obj.ADF4371Phase, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',359999}, ...
                '', 'ADF4371Phase');
            obj.ADF4371Phase = value;
            if obj.ConnectedToDevice
                setAttributeLongLong(obj,obj.ADF4371Channel,'phase',value,true,0,obj.ADF4371Device);
            end
        end

        function set.ADF4371Channel(obj, value)
            obj.ADF4371Channel = value;
        end

        function set.MUXOutEnable(obj, value)
            obj.MUXOutEnable = value;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.ADRF5720DeviceNames)
                    obj.setDeviceAttributeRAW('muxout_enable', num2str(value), obj.ADF4371Device);
                end
            end
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.ADF4371Device = cell(1,length(obj.ADF4371DeviceName));            
            for k = 1:numDevs
                devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                name = obj.iio_device_get_name(devPtr);
                if strcmpi(obj.ADF4371DeviceName,name)
                    obj.ADF4371Device = devPtr;
                end
            end
            if isempty(obj.ADF4371Device)
               error('%s not found',obj.ADF4371DeviceName);
            end            

            switch obj.ADF4371Name
                case 'RF8x'
                    setAttributeBool(obj,'altvoltage0','powerdown',false,true,obj.ADF4371Device);
                    obj.ADF4371Channel = 'altvoltage0';
                case 'RFAUX8x'
                    setAttributeBool(obj,'altvoltage1','powerdown',false,true,obj.ADF4371Device);
                    obj.ADF4371Channel = 'altvoltage1';
                case 'RF16x'
                    setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device);
                    obj.ADF4371Channel = 'altvoltage2';
                case 'RF32x'
                    setAttributeBool(obj,'altvoltage3','powerdown',false,true,obj.ADF4371Device);
                    obj.ADF4371Channel = 'altvoltage3';
                otherwise
                    error('Invalid setting chosen for ADF4371Name');
            end
            obj.setAttributeBool('altvoltage0','powerdown',true,true,obj.ADF4371Device);
            obj.setAttributeLongLong(obj.ADF4371Channel,'frequency',obj.ADF4371Frequency,true,0,obj.ADF4371Device);
            obj.setAttributeLongLong(obj.ADF4371Channel,'phase',obj.ADF4371Phase,true,0,obj.ADF4371Device);
            obj.setDeviceAttributeRAW('muxout_enable', num2str(obj.MUXOutEnable), obj.ADF4371Device);
        end
    end
end
