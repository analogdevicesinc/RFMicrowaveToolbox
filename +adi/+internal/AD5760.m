classdef (Abstract) AD5760 < adi.common.Attribute & ...
        adi.common.Channel & ...
        adi.common.DebugAttribute & ...
        matlabshared.libiio.base
    properties
        PowerDown = 1
        % PowerDownMode 
        % 0 - 6kohm_to_gnd
        % 1 - three_state
        PowerDownMode = 0        
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
                obj.PowerDownMode = repmat(obj.PowerDownMode, [1, numel(obj.AD5760DeviceNames)]);
            end
        end
        
        % Destructor
        function delete(obj)
        end
        
        function set.PowerDown(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',1}, ...
                    '', 'PowerDown');
            obj.PowerDown = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeRAW(obj,'powerdown',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end
        
        function set.PowerDownMode(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',1}, ...
                    '', 'PowerDownMode');
            obj.PowerDownMode = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)                    
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'powerdown_mode','6kohm_to_gnd',obj.DownCnvDevices{ii});
                    elseif (values(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'powerdown_mode','three_state',obj.DownCnvDevices{ii});
                    end
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
                    setAttributeDouble(obj,'voltage0','powerdown_mode',obj.PowerDownMode(:,ii),true,0,obj.AD5760Devices{ii});
                end
            end
        end
    end
end