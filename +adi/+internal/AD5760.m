classdef (Abstract) AD5760 < adi.common.Attribute & ...
        adi.common.Channel & ...
        adi.common.DebugAttribute & ...
        matlabshared.libiio.base
    properties
        %PowerDown 
        %   Power Down specified as a boolean
        PowerDown = true
        %PowerDownMode Power Down Mode
        %   specified as one of the following:
        %   '6kohm_to_gnd'
        %   'three_state'
        PowerDownMode = {'6kohm_to_gnd'}
    end
    
    properties
        %DACOut in mV
        %   Controls DAC output level in milli-Volts
        DACOut = 0
    end
    
    properties(Hidden, Constant)
        Offset = -32768
        Scale = 0.152590218
    end
    
    properties(Hidden)
        AD5760DeviceNames = {'ad5760'};
        AD5760Devices = {};
    end
    
    methods
        %% Constructor
        function obj = AD5760(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            if (nargin == 2) && strcmp(varargin{1},'AD5760DeviceNames')
                obj.AD5760DeviceNames = varargin{2};
            
                obj.PowerDown = repmat(obj.PowerDown, [1, numel(obj.AD5760DeviceNames)]);
                tmpVal = cell(1, numel(obj.AD5760DeviceNames));
                tmpVal(:) = obj.PowerDownMode;
                obj.PowerDownMode = tmpVal;
                tmpVal = int32((obj.DACOut-obj.Offset)/obj.Scale);
                tmpVal = double(tmpVal*obj.Scale+obj.Offset);
                obj.DACOut = repmat(tmpVal, [1, numel(obj.AD5760DeviceNames)]);
            end
        end
        
        % Destructor
        function delete(obj)
        end
        
        function set.PowerDown(obj, values)
            validateattributes( values, { 'logical' }, ...
                    { 'vector', 'nonnan', 'nonempty'}, '', 'PowerDown');
            obj.PowerDown = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.AD5760DeviceNames)
                    setDeviceAttributeRAW(obj,'powerdown',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end
        
        function set.PowerDownMode(obj, values)
            validateattributes( values, { 'cell', 'char' }, ...
                {'nonempty'}, '', 'PowerDownMode');
            obj.PowerDownMode = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.AD5760DeviceNames)                    
                    setDeviceAttributeRAW(obj,'powerdown_mode',values{ii},obj.DownCnvDevices{ii});                    
                end
            end
        end
        
        function set.DACOut(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'finite', 'nonnan', 'nonempty'},'', 'DACOut');
            obj.DACOut = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.AD5760DeviceNames)
                    tmpVal = int32(values(:,ii)-obj.Offset)/obj.Scale;
                    setDeviceAttributeRAW(obj,'raw',tmpVal,obj.DownCnvDevices{ii});
                end
            end
        end
    end
    
    methods (Hidden, Access = protected)        
        function setupInit(obj)
            % Do writes directly to hardware without using set methods.
            % This is required sine Simulink support doesn't support
            % modification to nontunable variables at SetupImpl
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.AD5760Devices = cell(1,length(obj.AD5760DeviceNames));
            for dn = 1:length(obj.AD5760DeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.AD5760DeviceNames{dn},name)
                        obj.AD5760Devices{dn} = devPtr;
                    end
                end
                if isempty(obj.AD5760Devices{dn})
                   error('%s not found',obj.AD5760DeviceNames{dn});
                end
            end

            if obj.ConnectedToDevice
                for ii = 1:length(obj.AD5760DeviceNames)
                    setAttributeDouble(obj,'voltage0','powerdown',obj.PowerDown(:,ii),true,0,obj.AD5760Devices{ii});
                    setAttributeDouble(obj,'voltage0','powerdown_mode',obj.PowerDownMode{ii},true,0,obj.AD5760Devices{ii});
                    setAttributeDouble(obj,'voltage0','raw',obj.DACOut(:,ii),true,0,obj.AD5760Devices{ii});
                end
            end
        end
    end
end