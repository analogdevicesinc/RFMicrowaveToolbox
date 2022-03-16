classdef (Abstract) ADRF5720 < adi.common.Attribute & ...
        adi.common.Channel & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties
        ADRF5720Gain = -31.5
    end
    
    properties(Hidden)
        ADRF5720DeviceNames = {'adrf5720'};    
        ADRF5720Devices = {};
    end
        
    methods
        %% Constructor
        function obj = ADRF5720(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            if (nargin == 2) && strcmp(varargin{1},'ADRF5720DeviceNames')
                obj.ADRF5720DeviceNames = varargin{2};
            
                obj.ADRF5720Gain = repmat(obj.ADRF5720Gain, [1, numel(obj.ADRF5720DeviceNames)]);         
            end
        end
        
        % Destructor
        function delete(obj)
        end
        
        function set.ADRF5720Gain(obj, values)
            validateattributes( values, { 'double','single' }, ...
                { 'real', 'vector', 'finite', 'nonnan', 'nonempty', '>=', -31.5,'<=', -0.5}, ...
                '', 'ADRF5720Gain');
            obj.ADRF5720Gain = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.ADRF5720DeviceNames)
                    setDeviceAttributeLongLong(obj,'voltage0','hardwaregain',values(:,ii),true,0,obj.ADRF5720Devices{ii});
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
            obj.ADRF5720Devices = cell(1,length(obj.ADRF5720DeviceNames));
            for dn = 1:length(obj.ADRF5720DeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.ADRF5720DeviceNames{dn},name)
                        obj.ADRF5720Devices{dn} = devPtr;
                    end
                end
                if isempty(obj.ADRF5720Devices{dn})
                   error('%s not found',obj.ADRF5720DeviceNames{dn});
                end
            end

            if obj.ConnectedToDevice
                for ii = 1:length(obj.ADRF5720DeviceNames)
                    setAttributeDouble(obj,'hardwaregain',obj.ADRF5720Gain(:,ii),obj.ADRF5720Devices{ii});                    
                end
            end
        end
    end
end