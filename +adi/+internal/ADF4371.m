classdef ADF4371 < adi.common.Attribute & adi.common.Rx
    % ADF4371 Wideband Synthesizer with Integrated VCO
    %
    % IIO Driver: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-pll/adf4371
    properties
        %ADF4371Name ADF4371 Name
        %   Configure programmable divider for ADF4371
        %   Options: 'RF16x' or 'RF32x'
        ADF4371Name (1,1) string {mustBeMember(ADF4371Name, ["RF16x", "RF32x"])} = "RF16x";
        %ADF4371Frequency ADF4371 Frequency 
        %   Configure ADF4371 output frequency
        %   Allowed range:
        %   'RF16x': >= 8GHz, <= 16 GHz
        %   'RF32x': >= 16GHz, <= 32 GHz
        ADF4371Frequency = 15000000000
        %ADF4371Frequency ADF4371 phase 
        %   Configure ADF4371 output phase in milli-degrees
        %   Range: 0-359999
        ADF4371Phase = 359999
        %MUXOutEnable MUXOut Enable 
        %   Enable output multiplexer on the ADF4371
        MUXOutEnable = true
        % ADF4371FrequencyDeviationRange = 500e6/4;
        % ADF4371FrequencyDeviationTime = 1e3;
        % ADF4371RampMode = 'Disabled';
        % ADF4371DelayWord = 4095;
        % ADF4371DelayClock = "PFD";
        % ADF4371DelayStart = 0;
        % ADF4371RampDelayEnable = 0;
        % ADF4371TriangleDelayEnable = 0;
        % ADF4371SingleFullTriangle = 0;
        % ADF4371TxTriggerEnable = 0;
        % ADF4371Clk1Value = 100;
        % ADF4371PhaseValue = 3;
        % ADF4371Enable = 0;
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
            if obj.ConnectedToDevice                
                switch value
                    % inverted logic to enable the correct channel
                    case 'RF16x'
                        setAttributeBool(obj,'altvoltage0','powerdown',true,true,obj.ADF4371Device,false);
                        setAttributeBool(obj,'altvoltage1','powerdown',true,true,obj.ADF4371Device,false);
                        setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device,false);
                        setAttributeBool(obj,'altvoltage3','powerdown',true,true,obj.ADF4371Device,false);
                        obj.ADF4371Channel = 'altvoltage2';
                    case 'RF32x'
                        setAttributeBool(obj,'altvoltage0','powerdown',true,true,obj.ADF4371Device,false);
                        setAttributeBool(obj,'altvoltage1','powerdown',true,true,obj.ADF4371Device,false);
                        setAttributeBool(obj,'altvoltage2','powerdown',true,true,obj.ADF4371Device,false);
                        setAttributeBool(obj,'altvoltage3','powerdown',false,true,obj.ADF4371Device,false);
                        obj.ADF4371Channel = 'altvoltage3';
                    otherwise
                        error('Invalid setting chosen for ADF4371Name');
                end
            end
            obj.ADF4371Name = value;
        end

        function set.ADF4371Frequency(obj, value)
            switch obj.ADF4371Name
                case 'RF16x'
                    validateattributes( value,{ 'double','single', 'uint64' }, ...
                        { 'real', 'nonnegative','scalar','finite','nonnan', 'nonempty',...
                        '>=',8000000000,'<=',16000000000},'', 'ADF4371Frequency');
                case 'RF32x'
                    validateattributes( value,{ 'double','single', 'uint64' }, ...
                        { 'real', 'nonnegative','scalar','finite','nonnan', 'nonempty',...
                        '>=',16000000000,'<=',32000000000},'', 'ADF4371Frequency');
            end
            obj.ADF4371Frequency = value;
            if obj.ConnectedToDevice
                setAttributeLongLong(obj,obj.ADF4371Channel,'frequency',value,true,0,obj.ADF4371Device,false);
            end
        end

        function set.ADF4371Phase(obj, value)
            validateattributes( value, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',359999}, ...
                '', 'ADF4371Phase');
            obj.ADF4371Phase = value;
            if obj.ConnectedToDevice
                setAttributeLongLong(obj,obj.ADF4371Channel,'phase',value,true,1,obj.ADF4371Device,false);
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
            obj.ADF4371Device = obj.getDev(obj.ADF4371DeviceName);
            if isempty(obj.ADF4371Device)
               error('%s not found',obj.ADF4371DeviceName);
            end            

            switch obj.ADF4371Name
                case 'RF16x'
                    setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device);
                    obj.ADF4371Channel = 'altvoltage2';
                case 'RF32x'
                    setAttributeBool(obj,'altvoltage3','powerdown',false,true,obj.ADF4371Device);
                    obj.ADF4371Channel = 'altvoltage3';
                otherwise
                    error('Invalid setting chosen for ADF4371Name');
            end
            setAttributeBool(obj,'altvoltage0','powerdown',true,true,obj.ADF4371Device, false);
            setAttributeBool(obj,'altvoltage1','powerdown',true,true,obj.ADF4371Device, false);
            setAttributeBool(obj,'altvoltage2','powerdown',false,true,obj.ADF4371Device, false);
            setAttributeBool(obj,'altvoltage3','powerdown',true,true,obj.ADF4371Device, false);
            obj.setAttributeLongLong(obj.ADF4371Channel,'frequency',obj.ADF4371Frequency,true,0,obj.ADF4371Device);
            obj.setAttributeLongLong(obj.ADF4371Channel,'phase',obj.ADF4371Phase,true,1,obj.ADF4371Device);
            obj.setDeviceAttributeRAW('muxout_enable', num2str(obj.MUXOutEnable), obj.ADF4371Device);
        end
    end
end
