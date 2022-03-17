classdef (Abstract) ADL5240 < adi.common.Attribute & ...
        adi.common.Channel & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties
        ADL5240Gain = -11.5
    end
    
    properties(Hidden)
        ADL5240DeviceNames = {'ADL5240'};    
        ADL5240Devices = {};
    end
        
    methods
        %% Constructor
        function obj = ADL5240(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            if (nargin == 2) && strcmp(varargin{1},'ADL5240DeviceNames')
                obj.ADL5240DeviceNames = varargin{2};
            
                obj.ADL5240Gain = repmat(obj.ADL5240Gain, [1, numel(obj.ADL5240DeviceNames)]);         
            end
        end
        
        % Destructor
        function delete(obj)
        end
        
        function set.ADL5240Gain(obj, values)
            validateattributes( values, { 'double','single' }, ...
                { 'real', 'vector', 'finite', 'nonnan', 'nonempty', '>=', -31.5,'<=', -0.5}, ...
                '', 'ADL5240Gain');
            obj.ADL5240Gain = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.ADL5240DeviceNames)
                    setAttributeDouble(obj,'voltage0','hardwaregain',values(:,ii),true,0,obj.ADL5240Devices{ii});
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
            obj.ADL5240Devices = cell(1,length(obj.ADL5240DeviceNames));
            for dn = 1:length(obj.ADL5240DeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.ADL5240DeviceNames{dn},name)
                        obj.ADL5240Devices{dn} = devPtr;
                    end
                end
                if isempty(obj.ADL5240Devices{dn})
                   error('%s not found',obj.ADL5240DeviceNames{dn});
                end
            end

            if obj.ConnectedToDevice
                for ii = 1:length(obj.ADL5240DeviceNames)
                    setAttributeDouble(obj,'voltage0','hardwaregain',obj.ADL5240Gain(:,ii),true,0,obj.ADL5240Devices{ii});
                end
            end
        end
    end
end