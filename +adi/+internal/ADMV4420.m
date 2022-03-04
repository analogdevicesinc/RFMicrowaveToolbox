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
        downCnvDeviceNames = {...
            'admv4420_CSB1',...
            'admv4420_CSB2'};
        downCnvDevices = {};
    end
        
    methods
        %% Constructor
        function obj = ADMV4420(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});            
        end
        
        % Destructor
        function delete(obj)
        end
    end

    methods
        function values = get.LOFreqHz(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'lo_freq_hz',obj.downCnvDevices{ii});
            end
        end

        function set.LOFreqHz(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'lo_freq_hz',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.MuxSel(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                tmp = getDeviceAttributeRAW(obj,'mux_sel',128,obj.downCnvDevices{ii});
                if strcmp('LOW',tmp)
                    values(:,ii) = 0;
                elseif strcmp('LOCK_DTCT',tmp)
                    values(:,ii) = 1;
                elseif strcmp('R_COUNTER_PER_2',tmp)
                    values(:,ii) = 2;
                elseif strcmp('N_COUNTER_PER_2',tmp)
                    values(:,ii) = 3;
                elseif strcmp('HIGH',tmp)
                    values(:,ii) = 4;
                end
            end
        end

        function set.MuxSel(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
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
                    setDeviceAttributeRAW(obj,'mux_sel',tmp,obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.NCounterFracVal(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'n_counter_frac_val',obj.downCnvDevices{ii});
            end
        end

        function set.NCounterFracVal(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'n_counter_frac_val',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.NCounterIntVal(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'n_counter_int_val',obj.downCnvDevices{ii});
            end
        end

        function set.NCounterIntVal(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'n_counter_int_val',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.NCounterModVal(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'n_counter_mod_val',obj.downCnvDevices{ii});
            end
        end

        function set.NCounterModVal(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'n_counter_mod_val',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.PFDFreqHz(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'pfd_freq_hz',obj.downCnvDevices{ii});
            end
        end

        function set.PFDFreqHz(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'pfd_freq_hz',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.RefDivBy2(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                if strcmp(...
                        'disabled',...
                        getDeviceAttributeRAW(obj,'ref_divide_by_2',128,obj.downCnvDevices{ii}))
                    values(:,ii) = 0;
                elseif strcmp(...
                        'enabled',...
                        getDeviceAttributeRAW(obj,'ref_divide_by_2',128,obj.downCnvDevices{ii}))
                    values(:,ii) = 1;
                end
            end
        end

        function set.RefDivBy2(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_divide_by_2','disabled',obj.downCnvDevices{ii});
                    elseif (values(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'ref_divide_by_2','enabled',obj.downCnvDevices{ii});
                    end
                end
            end
        end

        function values = get.RefDivider(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'ref_divider',obj.downCnvDevices{ii});
            end
        end

        function set.RefDivider(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'ref_divider',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.RefDoubler(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                if strcmp(...
                        'disabled',...
                        getDeviceAttributeRAW(obj,'ref_doubler',128,obj.downCnvDevices{ii}))
                    values(:,ii) = 0;
                elseif strcmp(...
                        'enabled',...
                        getDeviceAttributeRAW(obj,'ref_doubler',128,obj.downCnvDevices{ii}))
                    values(:,ii) = 1;
                end
            end
        end

        function set.RefDoubler(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_doubler','disabled',obj.downCnvDevices{ii});
                    elseif (values(:,ii) == 1)
                        setDeviceAttributeRAW(obj,'ref_doubler','enabled',obj.downCnvDevices{ii});
                    end
                end
            end
        end

        function values = get.RefFreqHz(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'ref_freq_hz',obj.downCnvDevices{ii});
            end
        end

        function set.RefFreqHz(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'ref_freq_hz',values(:,ii),obj.downCnvDevices{ii});
                end
            end
        end

        function values = get.RefType(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                if strcmp(...
                        'XTAL',...
                        getDeviceAttributeRAW(obj,'ref_type',128,obj.downCnvDevices{ii}))
                    values(:,ii) = 0;
%                 elseif strcmp(...
%                         'enabled',...
%                         getDeviceAttributeRAW(obj,'ref_type',128,obj.downCnvDevices{ii}))
%                     values(:,ii) = 1;
                end
            end
        end

        function set.RefType(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    if (values(:,ii) == 0)
                        setDeviceAttributeRAW(obj,'ref_type','XTAL',obj.downCnvDevices{ii});
%                     elseif (values(:,ii) == 1)
%                         setDeviceAttributeRAW(obj,'ref_type','enabled',obj.downCnvDevices{ii});
                    end
                end
            end
        end

        function values = get.VCOFreqHz(obj)
            values = zeros(1, length(obj.downCnvDeviceNames));
            for ii = 1:length(obj.downCnvDeviceNames)
                values(:,ii) = getDeviceAttributeLongLong(obj,'vco_freq_hz',obj.downCnvDevices{ii});
            end
        end

        function set.VCOFreqHz(obj, values)
            if obj.ConnectedToDevice
                for ii = 1:length(obj.downCnvDeviceNames)
                    setDeviceAttributeLongLong(obj,'vco_freq_hz',values(:,ii),obj.downCnvDevices{ii});
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
            obj.downCnvDevices = cell(1,length(obj.downCnvDeviceNames));
            for dn = 1:length(obj.downCnvDeviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.downCnvDeviceNames{dn},name)
                        obj.downCnvDevices{dn} = devPtr;
                    end
                end
                if isempty(obj.downCnvDevices{dn})
                   error('%s not found',obj.downCnvDeviceNames{dn});
                end
            end
        end
    end
end