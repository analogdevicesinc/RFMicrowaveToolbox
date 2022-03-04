classdef (Abstract) ADMV4420 < adi.common.Attribute & ...
        adi.common.Channel & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties
        %% LO Frequency in Hz
        LOFreqHz = 17500000000
        %% Mux Select
        % 0 - LOW
        % 1 - LOCK_DTCT
        % 2 - R_COUNTER_PER_2
        % 3 - N_COUNTER_PER_2
        % 4 - HIGH
        MuxSel = 0
        NCounterFracVal = 0
        NCounterIntVal = 175
        NCounterModVal = 1
        PFDFreqHz = 50000000
        %% Ref Fivide By 2
        % 0 - disabled
        % 1 - enabled
        RefDivBy2 = 0
        RefDivider = 1
        %% Ref Doubler
        % 0 - disabled
        % 1 - enabled
        RefDoubler = 0
        RefFreqHz = 50000000
        %% Reference Type
        % XTAL - 0
        RefType = 0
        VCOFreqHz = 8750000000
    end
    
    properties(Hidden)
        DownCnvDeviceNames = {'admv4420'};    
        DownCnvDevices = {};
    end
        
    methods
        %% Constructor
        function obj = ADMV4420(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            if (nargin == 2) && strcmp(varargin{1},'DownCnvDeviceNames')
                obj.DownCnvDeviceNames = varargin{2};
            
                obj.LOFreqHz = repmat(obj.LOFreqHz, [1, numel(obj.DownCnvDeviceNames)]);
                obj.MuxSel = repmat(obj.MuxSel, [1, numel(obj.DownCnvDeviceNames)]);
                obj.NCounterFracVal = repmat(obj.NCounterFracVal, [1, numel(obj.DownCnvDeviceNames)]);
                obj.NCounterIntVal = repmat(obj.NCounterIntVal, [1, numel(obj.DownCnvDeviceNames)]);
                obj.NCounterModVal = repmat(obj.NCounterModVal, [1, numel(obj.DownCnvDeviceNames)]);
                obj.PFDFreqHz = repmat(obj.PFDFreqHz, [1, numel(obj.DownCnvDeviceNames)]);
                obj.RefDivBy2 = repmat(obj.RefDivBy2, [1, numel(obj.DownCnvDeviceNames)]);
                obj.RefDivider = repmat(obj.RefDivider, [1, numel(obj.DownCnvDeviceNames)]);
                obj.RefDoubler = repmat(obj.RefDoubler, [1, numel(obj.DownCnvDeviceNames)]);
                obj.RefFreqHz = repmat(obj.RefFreqHz, [1, numel(obj.DownCnvDeviceNames)]);
                obj.RefType = repmat(obj.RefType, [1, numel(obj.DownCnvDeviceNames)]);
                obj.VCOFreqHz = repmat(obj.VCOFreqHz, [1, numel(obj.DownCnvDeviceNames)]);                
            end
        end
        
        % Destructor
        function delete(obj)
        end
    end

    methods
        function set.LOFreqHz(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','>=',16.35e9,'<=',21.15e9}, ...
                    '', 'LOFreqHz');
            obj.LOFreqHz = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'lo_freq_hz',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.MuxSel(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',4}, ...
                    '', 'MuxSel');
            obj.MuxSel = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    if (values(:,ii) == 0)
                        tmp = 'LOW';
                    elseif (values(:,ii) == 1)
                        tmp = 'LOCK_DTCT';
                    elseif (values(:,ii) == 2)
                        tmp = 'R_COUNTER_PER_2';
                    elseif (values(:,ii) == 3)
                        tmp = 'N_COUNTER_PER_2';
                    elseif (values(:,ii) == 4)
                        tmp = 'HIGH';
                    end
                    setDeviceAttributeRAW(obj,'mux_sel',tmp,obj.DownCnvDevices{ii});
                end
            end
        end

        function set.NCounterFracVal(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',16777215}, ...
                    '', 'NCounterFracVal');
            obj.NCounterFracVal = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'n_counter_frac_val',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.NCounterIntVal(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','>=',75,'<=',65535}, ...
                    '', 'NCounterIntVal');
            obj.NCounterIntVal = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'n_counter_int_val',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.NCounterModVal(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','>=',1,'<=',16777215}, ...
                    '', 'NCounterModVal');
            obj.NCounterModVal = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'n_counter_mod_val',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.PFDFreqHz(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','<=',50e6}, ...
                    '', 'PFDFreqHz');
            obj.PFDFreqHz = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'pfd_freq_hz',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.RefDivBy2(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',1}, ...
                    '', 'RefDivBy2');
            obj.RefDivBy2 = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_divide_by_2','disabled',obj.DownCnvDevices{ii});
                    elseif (values(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'ref_divide_by_2','enabled',obj.DownCnvDevices{ii});
                    end
                end
            end
        end

        function set.RefDivider(obj, values)
            obj.RefDivider = values;
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','>=',1,'<=',1023}, ...
                    '', 'RefDivider');
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'ref_divider',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.RefDoubler(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',1}, ...
                    '', 'RefDoubler');
            obj.RefDoubler = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_doubler','disabled',obj.DownCnvDevices{ii});
                    elseif (values(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'ref_doubler','enabled',obj.DownCnvDevices{ii});
                    end
                end
            end
        end

        function set.RefFreqHz(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','<=',50e6}, ...
                    '', 'RefFreqHz');
            obj.RefFreqHz = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'ref_freq_hz',values(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end

        function set.RefType(obj, values)
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'nonnegative','finite', 'nonnan', 'nonempty','integer','>=',0,'<=',1}, ...
                    '', 'RefType');
            obj.RefType = values;
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_type','XTAL',obj.DownCnvDevices{ii});
%                     elseif (values(:,ii) == 1)
%                         setDeviceAttributeRAW(obj,'ref_type','enabled',obj.DownCnvDevices{ii});
                    end
                end
            end
        end

        function set.VCOFreqHz(obj, values)
            obj.VCOFreqHz = values;
            validateattributes( values, { 'double','single' }, ...
                    { 'real', 'positive','finite', 'nonnan', 'nonempty','integer','>=',8.375e9,'<=',10.575e9}, ...
                    '', 'VCOFreqHz');
            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'vco_freq_hz',values(:,ii),obj.DownCnvDevices{ii});
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
            obj.DownCnvDevices = cell(1,length(obj.DownCnvDeviceNames));
            for dn = 1:length(obj.DownCnvDeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.DownCnvDeviceNames{dn},name)
                        obj.DownCnvDevices{dn} = devPtr;
                    end
                end
                if isempty(obj.DownCnvDevices{dn})
                   error('%s not found',obj.DownCnvDeviceNames{dn});
                end
            end

            if obj.ConnectedToDevice
                for ii = 1:length(obj.DownCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'lo_freq_hz',obj.LOFreqHz(:,ii),obj.DownCnvDevices{ii});
                    
                    if (obj.MuxSel(:,ii) == 0)
                        tmp = 'LOW';
                    elseif (obj.MuxSel(:,ii) == 1)
                        tmp = 'LOCK_DTCT';
                    elseif (obj.MuxSel(:,ii) == 2)
                        tmp = 'R_COUNTER_PER_2';
                    elseif (obj.MuxSel(:,ii) == 3)
                        tmp = 'N_COUNTER_PER_2';
                    elseif (obj.MuxSel(:,ii) == 4)
                        tmp = 'HIGH';
                    end
                    setDeviceAttributeRAW(obj,'mux_sel',tmp,obj.DownCnvDevices{ii});
                    
                    setDeviceAttributeLongLong(obj,'n_counter_frac_val',obj.NCounterFracVal(:,ii),obj.DownCnvDevices{ii});
                    setDeviceAttributeLongLong(obj,'n_counter_int_val',obj.NCounterIntVal(:,ii),obj.DownCnvDevices{ii});
                    setDeviceAttributeLongLong(obj,'n_counter_mod_val',obj.NCounterModVal(:,ii),obj.DownCnvDevices{ii});

                    setDeviceAttributeLongLong(obj,'pfd_freq_hz',obj.PFDFreqHz(:,ii),obj.DownCnvDevices{ii});

                    if (obj.RefDivBy2(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_divide_by_2','disabled',obj.DownCnvDevices{ii});
                    elseif (obj.RefDivBy2(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'ref_divide_by_2','enabled',obj.DownCnvDevices{ii});
                    end

                    setDeviceAttributeLongLong(obj,'ref_divider',obj.RefDivider(:,ii),obj.DownCnvDevices{ii});

                    if (obj.RefDoubler(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_doubler','disabled',obj.DownCnvDevices{ii});
                    elseif (obj.RefDoubler(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'ref_doubler','enabled',obj.DownCnvDevices{ii});
                    end

                    setDeviceAttributeLongLong(obj,'ref_freq_hz',obj.RefFreqHz(:,ii),obj.DownCnvDevices{ii});

                    if (obj.RefType(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_type','XTAL',obj.DownCnvDevices{ii});
%                     elseif (obj.RefType(:,ii) == 1)
%                         setDeviceAttributeRAW(obj,'ref_type','enabled',obj.DownCnvDevices{ii});
                    end

                    setDeviceAttributeLongLong(obj,'vco_freq_hz',obj.VCOFreqHz(:,ii),obj.DownCnvDevices{ii});
                end
            end
        end
    end
end