classdef ADF4159 < adi.common.Attribute & adi.common.Rx
    % ADF4159 Direct Modulation/Fast Waveform Generating Synthesizer
    %
    % IIO Driver: https://wiki.analog.com/resources/tools-software/linux-drivers

    properties
        %Frequency Frequency
        %   Set output frequency of synthesizer in Hz. When the synthesizer
        %   is ramping this is the start frequency
        Frequency = 1e9;
        %FrequencyDeviationRange Frequency Deviation Range
        %   Set upper bound on frequency ramp from Frequency property in Hz.
        %   This is only applicable when RampMode is not set to "disabled"
        FrequencyDeviationRange = 1e6;
        %FrequencyDeviationStep Frequency Deviation Step
        %   Set step size in Hz of synthesizer ramp. This is only
        %   applicable when RampMode is not set to "disabled".
        FrequencyDeviationStep = 500e6 / 4 / 1000;
        %FrequencyDeviationTime Frequency Deviation Time
        %   Set time in uSeconds to reach ramp peak value. This is only
        %   applicable when RampMode is not set to "disabled"
        FrequencyDeviationTime = 0;
        %RampMode Ramp Mode
        %   Set ramp waveform. Options are:
        %   - "disabled"
        %   - "continuous_sawtooth"
        %   - "continuous_triangular"
        %   - "single_sawtooth_burst"
        %   - "single_ramp_burst"
        RampMode (1,1) string {mustBeMember(RampMode, ["disabled", "continuous_sawtooth", "continuous_triangular", "single_sawtooth_burst", "single_ramp_burst"])} = "disabled";
    end

    properties(Logical)
        %Powerdown
        %   When true output will be disabled. Writing to this value will
        %   also update all settings of device
        Powerdown = false;
    end

    properties% Advanced
        %DelayStartWord Delay Start Word
        %   Set start delay of each ramp in PFD or PFD*CLK1 clock cycles.
        %   This is a 12-bit number
        DelayStartWord = 0;
        %DelayClockSource Delay Clock Source
        %   Set clock use to determine ramp delay. Options are:
        %   - "PFD"
        %   - "PFD*CLK1"
        DelayClockSource (1,1) string {mustBeMember(DelayClockSource, ["PFD","PFD*CLK1"])} = "PFD";
    end

    properties(Logical)%Advanced
        %DelayStartEnable Ramp Delay Enable
        %   Enable delaying of ramp signal at start of first ramp generation
        DelayStartEnable = false;
        %RampDelayEnable Ramp Delay Enable
        %   Enable delaying of ramp signal at start of each ramp generation
        RampDelayEnable = false;
        %TriggerDelayEnable Trigger Delay Enable
        %   Enable ramp start delay when controlled by external trigger
        TriggerDelayEnable = false;
        %TriggerEnable Trigger Enable
        %   Allow for use of external trigger on TX Data pin to start ramp
        TriggerEnable = false;
        %SingleFullTriangleEnable Single Full Triangle Enable
        %   Enable sending of single full triangular wave. This is
        %   applicable when RampMode is in "single_ramp_burst"
        SingleFullTriangleEnable = false;
    end
    
    properties(Hidden)
        devNameADF4159 = 'adf4159';
        iioDeviceADF4159;
    end
        
    methods

        function set.Frequency(obj,value)
            setAttributeLongLong(obj, 'altvoltage0', 'frequency', int64(value), true, 1000, obj.iioDeviceADF4159);
            rvalue = getAttributeLongLong(obj, 'altvoltage0', 'frequency', true, obj.iioDeviceADF4159);
            obj.Frequency = rvalue;
        end
        function set.FrequencyDeviationRange(obj,value)
            setAttributeLongLong(obj, 'altvoltage0', 'frequency_deviation_range', int64(value), true, 20000, obj.iioDeviceADF4159);
            rvalue = obj.getAttributeLongLong('altvoltage0', 'frequency_deviation_range',true, obj.iioDeviceADF4159);
            obj.FrequencyDeviationRange = rvalue;
        end
        function set.FrequencyDeviationStep(obj,value)
            setAttributeLongLong(obj, 'altvoltage0', 'frequency_deviation_step', int64(value), true, 40, obj.iioDeviceADF4159);
            rvalue = obj.getAttributeLongLong('altvoltage0', 'frequency_deviation_step',true, obj.iioDeviceADF4159);
            obj.FrequencyDeviationStep = rvalue;
        end
        function set.FrequencyDeviationTime(obj,value)
            setAttributeLongLong(obj, 'altvoltage0', 'frequency_deviation_time', int64(value), true, 40, obj.iioDeviceADF4159);
            rvalue = obj.getAttributeLongLong('altvoltage0', 'frequency_deviation_time',true, obj.iioDeviceADF4159);
            obj.FrequencyDeviationTime = rvalue;
        end
        function set.RampMode(obj,value)
            setAttributeRAW(obj, 'altvoltage0', 'ramp_mode', char(value), true, obj.iioDeviceADF4159);
            obj.RampMode = value;
        end
        function set.Powerdown(obj,value)
            setAttributeBool(obj,'altvoltage0','powerdown',value,true, obj.iioDeviceADF4159);
            obj.Powerdown = value;
        end

        function set.DelayStartWord(obj,value)
            setDebugAttributeLongLong(obj, 'adi,delay-start-word', value, true, obj.iioDeviceADF4159);
            obj.DelayStartWord = value;
            obj.ToggleUpdown();
        end
        function set.DelayClockSource(obj,value)
            setDebugAttributeRAW(obj, 'adi,delay-clk-sel-pfd-x-clk1-enable', char(value), obj.iioDeviceADF4159);
            obj.DelayClockSource = value;
            obj.ToggleUpdown();            
        end

        function set.DelayStartEnable(obj,value)
            setDebugAttributeBool(obj, 'adi,delay-start-enable', value, true, obj.iioDeviceADF4159);
            obj.DelayStartEnable = value;
            obj.ToggleUpdown();            
        end
        function set.RampDelayEnable(obj,value)
            setDebugAttributeBool(obj, 'adi,ramp-delay-enable', value, true, obj.iioDeviceADF4159);
            obj.RampDelayEnable = value;
            obj.ToggleUpdown();            
        end
        function set.TriggerDelayEnable(obj,value)
            setDebugAttributeBool(obj, 'adi,txdata-trigger-delay-enable', value, true, obj.iioDeviceADF4159);
            obj.TriggerDelayEnable = value;
            obj.ToggleUpdown();            
        end
        function set.TriggerEnable(obj,value)
            setDebugAttributeBool(obj, 'adi,txdata-trigger-enable', value, true, obj.iioDeviceADF4159);
            obj.TriggerEnable = value;
            obj.ToggleUpdown();            
        end
        function set.SingleFullTriangleEnable(obj,value)
            setDebugAttributeBool(obj, 'adi,single-full-triangle-enable', value, true, obj.iioDeviceADF4159);
            obj.SingleFullTriangleEnable = value;
            obj.ToggleUpdown();            
        end

    end

    methods(Access = protected)

        function ToggleUpdown(obj)
            cstate = obj.getAttributeBool('altvoltage0', 'powerdown', true, obj.iioDeviceADF4159);
            obj.setAttributeBool('altvoltage0', 'powerdown', ~cstate, true, obj.iioDeviceADF4159);
            obj.setAttributeBool('altvoltage0', 'powerdown', cstate, true, obj.iioDeviceADF4159);
        end

    end

    methods (Hidden, Access = protected)        
        function setupInit(obj)
            % Do writes directly to hardware without using set methods.
            % This is required sine Simulink support doesn't support
            % modification to nontunable variables at SetupImpl
            obj.iioDeviceADF4159 = obj.getDev(obj.devNameADF4159);

            % Set defaults
            setAttributeLongLong(obj, 'altvoltage0', 'frequency', int64(obj.Frequency), true, 0, obj.iioDeviceADF4159);
            setAttributeLongLong(obj, 'altvoltage0', 'frequency_deviation_range', int64(obj.FrequencyDeviationRange), true, 20000, obj.iioDeviceADF4159, false);
            setAttributeLongLong(obj, 'altvoltage0', 'frequency_deviation_step', int64(obj.FrequencyDeviationStep), true, 40, obj.iioDeviceADF4159, false);
            setAttributeLongLong(obj, 'altvoltage0', 'frequency_deviation_time', int64(obj.FrequencyDeviationTime), true, 40, obj.iioDeviceADF4159, false);
            setAttributeRAW(obj, 'altvoltage0', 'ramp_mode', char(obj.RampMode), true, obj.iioDeviceADF4159);
            setAttributeBool(obj,'altvoltage0','powerdown', obj.Powerdown,true, obj.iioDeviceADF4159);

            setDebugAttributeLongLong(obj, 'adi,delay-start-word', obj.DelayStartWord, true, obj.iioDeviceADF4159);
            setDebugAttributeRAW(obj, 'adi,delay-clk-sel-pfd-x-clk1-enable', char(obj.DelayClockSource), obj.iioDeviceADF4159);
            setDebugAttributeBool(obj, 'adi,delay-start-enable', obj.DelayStartEnable, true, obj.iioDeviceADF4159);
            setDebugAttributeBool(obj, 'adi,ramp-delay-enable', obj.RampDelayEnable, true, obj.iioDeviceADF4159);
            setDebugAttributeBool(obj, 'adi,txdata-trigger-delay-enable', obj.TriggerDelayEnable, true, obj.iioDeviceADF4159);
            setDebugAttributeBool(obj, 'adi,txdata-trigger-enable', obj.TriggerEnable, true, obj.iioDeviceADF4159);
            setDebugAttributeBool(obj, 'adi,single-full-triangle-enable', obj.SingleFullTriangleEnable, true, obj.iioDeviceADF4159);

            % Update all part registers
            obj.ToggleUpdown();
        end
    end
end

%     # pll.clk1_value = 100
%     # pll.phase_value = 3
%     pll.enable = 0  # 0 = PLL enable.  Write this last to update all the registers