classdef Phaser < adi.internal.ADAR100x & ...
        adi.internal.ADF4159
    % adi.Phaser Analog Devices Inc. ADALM-PHASER beamformer development platform
    %   The adi.Phaser system object is an API to control the
    %   ADALM-PHASER X/Ku Band Beamforming Developer Platform.
    %
    %   rx = adi.Phaser;
    %   rx = adi.Phaser('uri','ip:192.168.2.1');
    %
    %   <a href="https://wiki.analog.com/resources/eval/developer-kits/x-band-dev-kit">Stingray X/Ku Band Beamforming Developer Platform Wiki</a>
    properties(Nontunable, Hidden)
        ElementToChipChannelMap = [3,4,1,2, 3,4,1,2]; % channel attributes
        ElementToChipMap = [2,2,2,2, 1,1,1,1]; % channel attributes
        SubarrayToChipMap = [2, 1]; % device attributes
    end

    properties(Logical)
        %EnablePLL Enable PLL
        % This controls V_CTRL_1
        % true = enable onboard PLL which is the main LO source. 
        % false = disable onboard PLL and enable external LO path
        EnablePLL = true;

        %EnableTxPLL Enable Tx PLL
        % This controls V_CTRL_2
        % true = send LO to transmit circuits
        % false = disable transmit path
        EnableTxPLL = true;

        %EnableOut1 Enable Tx SW
        % This controls TX_SW (GPIO_W)
        % true = send transmit to OUT1 SMA port
        % false = send transmit to OUT2 SMA port
        EnableOut1 = true;

        %Burst TDD Burst Trigger Input
        % Low to high on BURST triggers external input of TDD engine
        Burst = false;
    end

    properties
        %MonitorVDD1V8 1.8V Power Supply
        %   1.8V power supply voltage monitor
        MonitorVDD1V8 = 1.8;

        %MonitorVDD3V0 3.0V Power Supply
        %   3.0V power supply voltage monitor
        MonitorVDD3V0 = 3.0;

        %MonitorVDD3V3 3.3V Power Supply
        %   3.3V power supply voltage monitor
        MonitorVDD3V3 = 3.3;

        %MonitorVDD4V5 4.5V Power Supply
        %   4.5V power supply voltage monitor
        MonitorVDD4V5 = 4.5;

        %MonitorVDDAmp 14V Power Supply
        %   14V boost power supply voltage monitor
        MonitorVDDAmp = 14;

        %MonitorVinput 5V Input Power Supply
        %   USB-C 5V input power supply voltage monitor
        MonitorVinput = 5.0;

        %MonitorImon Board Input Current
        %   USB-C Input current monitor in Amps
        MonitorImon = 2.0;

        %MonitorVtune VCO Vtune Voltage
        %   Vtune voltage directly relates to VCO frequency
        MonitorVtune = 10.0;

        %MonitorBoardTemp Board Temp
        %   Board temperature monitor in deg C
        MonitorBoardTemp = 25.0;
    end

    properties(Hidden)
        deviceNames = {...
            'adar1000_0',...
            'adar1000_1'};
        GPIODevIIO;
        housekeepingADC;
    end
    
    properties
        NumADAR1000s = 2
    end
    
    methods
        %% Constructor
        function obj = Phaser(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.internal.ADAR100x(varargin{:});
            obj.TargetFrequency = 10492000000;
        end
        % Destructor
        function delete(obj)
        end

        function set.EnablePLL(obj, value)
            % VCTRL_1
            setAttributeBool(obj, 'voltage6', 'raw', value, true, obj.GPIODevIIO);
        end
        function result = get.EnablePLL(obj)
            result = nan;
            if ~isempty(obj.GPIODevIIO)
                result = obj.getAttributeBool('voltage6', 'raw', true, obj.GPIODevIIO);
            end
        end
        function set.EnableTxPLL(obj, value)
            % VCTRL_2
            setAttributeBool(obj, 'voltage7', 'raw', value, true, obj.GPIODevIIO);
        end
        function result = get.EnableTxPLL(obj)
            result = nan;
            if ~isempty(obj.GPIODevIIO)
                result = obj.getAttributeBool('voltage7', 'raw', true, obj.GPIODevIIO);
            end
        end
        function set.EnableOut1(obj, value)
            % TX_SW
            setAttributeRAW(obj, 'voltage8', 'raw', num2str(value), true, obj.GPIODevIIO);
        end
        function result = get.EnableOut1(obj)
            result = nan;
            if ~isempty(obj.GPIODevIIO)
                result = obj.getAttributeBool('voltage8', 'raw', true, obj.GPIODevIIO);
            end
        end

        function set.Burst(obj, value)
            % BURST
            setAttributeBool(obj, 'voltage9', 'raw', value, true, obj.GPIODevIIO);
        end
        function result = get.Burst(obj)
            result = nan;
            if ~isempty(obj.GPIODevIIO)
                result = obj.getAttributeBool('voltage9', 'raw', true, obj.GPIODevIIO);
            end
        end

        function result = get.MonitorVDD1V8(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage0', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage0', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (10.0 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorVDD3V0(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage1', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage1', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (10.0 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorVDD3V3(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage2', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage2', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (10.0 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorVDD4V5(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage3', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage3', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (30.1 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorVDDAmp(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage4', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage4', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (69.8 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorVinput(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage5', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage5', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (30.1 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorImon(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage6', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage6', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0; % LTC4217 IMON=50uA/A*20k = 1V/A
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorVtune(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('voltage7', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('voltage7', 'scale', false, obj.housekeepingADC));
                Rdivider = 1.0 + (69.8 / 10.0);   % resistor divider to AD7291 ADC input
                result = rvalue * scale * Rdivider / 1000;
            end
        end

        function result = get.MonitorBoardTemp(obj)
            result = nan;
            if ~isempty(obj.housekeepingADC)
                rvalue = str2double(obj.getAttributeRAW('temp0', 'raw', false, obj.housekeepingADC));
                scale = str2double(obj.getAttributeRAW('temp0', 'scale', false, obj.housekeepingADC));
                result = rvalue * scale / 1000;
            end
        end
    end

    methods (Hidden, Access = protected)
        function setupInit(obj)
            setupInit@adi.internal.ADAR100x(obj);
            % PLL
            setupInit@adi.internal.ADF4159(obj);
            % GPIO control pins
            obj.GPIODevIIO = obj.getDev('one-bit-adc-dac');
            setAttributeRAW(obj, 'voltage6', 'raw', num2str(obj.EnablePLL),  true, obj.GPIODevIIO);
            setAttributeRAW(obj, 'voltage7', 'raw', num2str(obj.EnableTxPLL), true, obj.GPIODevIIO);
            setAttributeRAW(obj, 'voltage9', 'raw', num2str(obj.Burst), true, obj.GPIODevIIO);

            % Set voltages on MR, s0, s1, and s2 for OUT1/OUT2 selection
            setAttributeBool(obj, 'voltage5', 'raw', true, true, obj.GPIODevIIO);  %MR GPIO_V
            setAttributeBool(obj, 'voltage0', 'raw', false, true, obj.GPIODevIIO);  %s0 GPIO_X
            setAttributeBool(obj, 'voltage3', 'raw', false, true, obj.GPIODevIIO);  %s1 GPIO_Y
            setAttributeBool(obj, 'voltage4', 'raw', false, true, obj.GPIODevIIO);  %s2 GPIO_Z
            setAttributeBool(obj, 'voltage8', 'raw', false, true, obj.GPIODevIIO);  %voltage8 is TX_SW GPIO_W

            % Houskeeping ADC to monitor voltages and current
            obj.housekeepingADC = obj.getDev('ad7291');
        end
    end
end
