classdef (Abstract) ADAR100x < adi.common.Attribute & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties (Constant, Hidden)
        BIAS_CODE_TO_VOLTAGE_SCALE = -0.018824
    end
    
    properties(Abstract, Nontunable, Hidden)
        ElementToChipChannelMap % channel attributes
        SubarrayToChipMap % device attributes
        deviceNames
    end
    
    properties(Nontunable, Hidden)
        kernelBuffersCount = 0;
        dataTypeStr = 'int16';
        iioDriverName = 'adar1000';
        devName = 'adar1000';
        SamplesPerFrame = 0;
        SkipInit = false;
    end
    
    properties (Hidden)
        iioDevices
    end
    
    properties (Hidden, Constant, Logical)
        ComplexData = false;
    end
    
    properties(Nontunable, Hidden, Constant)
        Type = 'Rx';
    end
    
    properties (Hidden, Nontunable, Access = protected)
        isOutput = false;
    end
    
    properties
        %Mode Mode
        %   Options are 'Rx', 'Tx', or 'disabled'
        Mode = {'Rx'}
        %LNABiasOutEnable Enables output of LNA bias DAC
        LNABiasOutEnable = false
        %LNABiasOn External Bias for External LNAs
        LNABiasOn = -0.8
        %BeamMemEnable Beam Memory Enable
        BeamMemEnable = false
        %BiasDACEnable Enables PA and LNA bias DACs
        BiasDACEnable = true
        %BiasDACMode External Am plifier Bias Control
        BiasDACMode = {'On'}
        %BiasMemEnable Bias Memory Enable
        BiasMemEnable = false
        %CommonMemEnable Common Memory Enable
        CommonMemEnable = false
        %CommonRxBeamState Static Rx Beam Position Load
        CommonRxBeamState = 0
        %CommonTxBeamState Static Tx Beam Position Load
        CommonTxBeamState = 0
        %ExternalTRPin Tx/Rx Output Driver Select
        ExternalTRPin = {'Pos'}
        %ExternalTRPolarity Controls Sense of Tx/Rx Switch Driver Output
        ExternalTRPolarity = true
        %LNABiasOff External Bias for External LNAs
        LNABiasOff = -2
        %PolState Control for External Polarity Switch Drivers
        PolState = false
        %PolSwitchEnable Enables Switch Driver for External Polarization Switch
        PolSwitchEnable = false
        %RxLNABiasCurrent LNA Bias Current Setting
        RxLNABiasCurrent = 8
        %RxLNAEnable Rx LNA Enable
        RxLNAEnable = true
        %RxToTxDelay1 LNA Bias off to TR Switch Delay
        RxToTxDelay1 = 0
        %RxToTxDelay2 TR Switch to PA Bias on Delay
        RxToTxDelay2 = 0
        %RxVGAEnable Enables the Rx Channel VGAs
        RxVGAEnable = true
        %RxVGABiasCurrentVM Rx Bias Current
        RxVGABiasCurrentVM = 85
        %RxVMEnable Enables the Rx Channel Vector Modulators
        RxVMEnable = true
        %SequencerEnable Sequencer Enable
        SequencerEnable = false
        %TRSwitchEnable Enables Switch Driver for External Tx/Rx Switch
        TRSwitchEnable = true
        %TxPABiasCurrent Tx Driver Bias Current Setting
        TxPABiasCurrent = 6
        %TxPAEnable Enables the Tx Channel Drivers
        TxPAEnable = false
        %TxToRxDelay1 PA Bias off to TR Switch Delay
        TxToRxDelay1 = 0
        %TxToRxDelay2 TR Switch to LNA Bias on Delay
        TxToRxDelay2 = 0
        %TxVGAEnable Enables the Tx Channel VGAs
        TxVGAEnable = true
        %TxVGABiasCurrentVM Tx Bias Current
        TxVGABiasCurrentVM = 45
        %TxVMEnable Enables the Tx Channel Vector Modulators
        TxVMEnable = true
        
        %DetectorEnable Detector Enable
        DetectorEnable = true(1, 4)
        %DetectorPower Detector Power
        DetectorPower = 255*ones(1, 4)
        %PABiasOff External Bias for External PA 
        PABiasOff = -2.484*ones(1, 4)
        %PABiasOn External Bias for External PA  
        PABiasOn = -2.484*ones(1, 4)
        %RxAttn Rx Attenuation
        RxAttn = true(1, 4)
        %RxBeamState Load Rx Position
        RxBeamState = zeros(1, 4)
        %RxPowerDown Rx Powerdown
        RxPowerDown = false(1, 4)
        %RxGain Rx Gain
        RxGain = ones(1, 4)
        %RxPhase Rx Phase
        RxPhase = zeros(1, 4)
        %TxAttn Tx Attenuation
        TxAttn = true(1, 4)
        %TxBeamState Load Tx Position
        TxBeamState = zeros(1, 4)
        %TxPowerDown Tx Powerdown
        TxPowerDown = false(1, 4)
        %TxGain Tx Gain
        TxGain = ones(1, 4)
        %TxPhase Tx Phase
        TxPhase = zeros(1, 4)
        % RxBiasState = zeros(1, 4)
        %RxSequencerStart Rx Sequencer Start
        RxSequencerStart = false(1, 4)
        %RxSequencerStop Rx Sequencer Stop
        RxSequencerStop = false(1, 4)
        % TxBiasState = zeros(1, 4)
        %TxSequencerStart Tx Sequencer Start
        TxSequencerStart = false(1, 4)
        %TxSequencerStop Tx Sequencer Stop
        TxSequencerStop = false(1, 4)
        %Temp ADAR1000 Temperature
        Temp = 0

        %TxRxSwitchControl TxRx Switch Control
        %   Set source of control for Rx and Tx switching.
        %   TxRxSwitchControl is a cellarray where each element address
        %   individual ADAR1000's. Each cell must contain a string of value
        %   'spi' or 'external' to set the modes.
        TxRxSwitchControl = {'spi'};
    end

    properties
        %TargetFrequency ADAR1000 TargetFrequency
        TargetFrequency = 10e9
        %ElementSpacing ADAR1000 Element Spacing
        ElementSpacing = 0.015
    end
    
    properties (Hidden, Access = private)
        %RxAzimuth Rx Azimuth
        RxAzimuth = 0
        %RxAzimuthPhi Rx Azimuth Phi
        RxAzimuthPhi = 0
        %RxElevation Rx Elevation
        RxElevation = 0
        %RxElevationPhi Rx Elevation Phi
        RxElevationPhi = 0
        %TxAzimuth Tx Azimuth
        TxAzimuth = 0
        %TxAzimuthPhi Tx Azimuth Phi
        TxAzimuthPhi = 0
        %TxElevation Tx Elevation
        TxElevation = 0
        %TxElevationPhi Tx Elevation Phi
        TxElevationPhi = 0
    end
    
    methods
        % Constructor
        function obj = ADAR100x(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            obj.updateDefaultProps();
        end
        
        % Destructor
        function delete(obj)
        end
        
        function updateDefaultProps(obj)
            DeviceProps = {'Mode', 'LNABiasOutEnable', 'LNABiasOn', ...
                'BeamMemEnable', 'BiasDACEnable', ...
                'BiasDACMode', 'BiasMemEnable', ...
                'CommonMemEnable', 'CommonRxBeamState', 'CommonTxBeamState', ...
                'ExternalTRPin', 'ExternalTRPolarity', 'LNABiasOff', ...
                'PolState', 'PolSwitchEnable', 'RxLNABiasCurrent', ...
                'RxLNAEnable', 'RxToTxDelay1', 'RxToTxDelay2', ...
                'RxVGAEnable', 'RxVGABiasCurrentVM', 'RxVMEnable', ...
                'SequencerEnable', 'TRSwitchEnable', 'TxPABiasCurrent', ...
                'TxPAEnable', 'TxToRxDelay1', 'TxToRxDelay2', ...
                'TxVGAEnable', 'TxVGABiasCurrentVM', 'TxVMEnable', 'TxRxSwitchControl'
            };
            ChannelProps = {
                'DetectorEnable', ...% 'DetectorPower', 
                'PABiasOff', 'PABiasOn', 'RxAttn', ...
                'RxBeamState', 'RxPowerDown', 'RxGain', ...
                'RxPhase', 'TxAttn', 'TxBeamState', ...
                'TxPowerDown', 'TxGain', ...
                'TxPhase', ...% RxBiasState = zeros(1, 4)
                'RxSequencerStart', 'RxSequencerStop', ...% 'TxBiasState', 
                'TxSequencerStart', 'TxSequencerStop'
            };
            
            % Device Properties
            for ii = 1:numel(DeviceProps)
                obj.(DeviceProps{ii}) = repmat(obj.(DeviceProps{ii})(1,1), size(obj.SubarrayToChipMap));
            end
            % Channel Properties
            for ii = 1:numel(ChannelProps)
                obj.(ChannelProps{ii}) = repmat(obj.(ChannelProps{ii})(1,1), size(obj.ElementToChipChannelMap));
            end
        end
        
        function result = getAllChipsChannelAttribute(obj, attr, isOutput, AttrClass)
            if strcmpi(AttrClass, 'logical')
                result = false(size(obj.ElementToChipChannelMap));
            elseif strcmpi(AttrClass, 'raw')
                result = zeros(size(obj.ElementToChipChannelMap));
            elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                result = zeros(size(obj.ElementToChipChannelMap));
            elseif strcmpi(AttrClass, 'double')
                result = zeros(size(obj.ElementToChipChannelMap));
            end
            for r = 1:size(obj.ElementToChipChannelMap,1)
                for c = 1:size(obj.ElementToChipChannelMap,2)
                    devIndx = obj.ElementToChipMap(r,c);
                    chanIndex = obj.ElementToChipChannelMap(r,c);
                    channel = sprintf('voltage%d', chanIndex-1);
                    if strcmpi(AttrClass, 'logical')
                        result(r, c) = obj.getAttributeBool(channel, attr, isOutput, obj.iioDevices{devIndx});
                    elseif strcmpi(AttrClass, 'raw')
                        result(r, c) = str2double(obj.getAttributeRAW(channel, attr, isOutput, obj.iioDevices{devIndx}));
                    elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                        result(r, c) = obj.getAttributeLongLong(channel, attr, isOutput, obj.iioDevices{devIndx});
                    elseif strcmpi(AttrClass, 'double')
                        result(r, c) = obj.getAttributeDouble(channel, attr, isOutput, obj.iioDevices{devIndx});
                    end
                end
            end
        end
        
        function setAllChipsChannelAttribute(obj, values, attr, isOutput, AttrClass, varargin)
            if (nargin == 6)
                Tol = varargin{1};
            else
                Tol = 0;
            end
            if strcmpi(AttrClass, 'logical')
                validateattributes(values, {'logical'},...
                    {'size', size(obj.ElementToChipChannelMap)});
            elseif strcmpi(AttrClass, 'raw') || ...
                    strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
%                 validateattributes(values, {'char','numeric', 'uint32'},...
%                     {'size', size(obj.ElementToChipChannelMap)});
            elseif strcmpi(AttrClass, 'double')
                validateattributes(values, {'numeric', 'double'},...
                    {'size', size(obj.ElementToChipChannelMap)});
            end
            
            if obj.ConnectedToDevice

                for r = 1:size(obj.ElementToChipChannelMap,1)
                    for c = 1:size(obj.ElementToChipChannelMap,2)
    
                        devIndx = obj.ElementToChipMap(r,c);
                        chanIndex = obj.ElementToChipChannelMap(r,c);
                        channel = sprintf('voltage%d', chanIndex-1);

                        if strcmpi(AttrClass, 'logical')
                            obj.setAttributeBool(channel, attr, ...
                                values(r, c), isOutput, obj.iioDevices{devIndx});
                        elseif strcmpi(AttrClass, 'raw')
                            if iscell(values)
                                value = values{r,c};
                            else
                                value = values(r, c);
                            end
                            obj.setAttributeRAW(channel, attr, ...
                                value, isOutput, obj.iioDevices{devIndx});
                        elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                            obj.setAttributeLongLong(channel, attr, ...
                                values(r, c), isOutput, Tol, obj.iioDevices{devIndx});
                        elseif strcmpi(AttrClass, 'double')
                            obj.setAttributeDouble(channel, attr, ...
                                values(r, c), isOutput, Tol, obj.iioDevices{devIndx});
                        end
                    end
                end
            end
        end
        
        function result = getAllChipsDeviceAttributeRAW(obj, attr, isBooleanAttr)
            if isBooleanAttr
                temp = false(size(obj.SubarrayToChipMap));
            else
                temp = zeros(size(obj.SubarrayToChipMap));
            end
            for r = 1:size(obj.SubarrayToChipMap,1)
                for c = 1:size(obj.SubarrayToChipMap,2)
                    devIndx = obj.SubarrayToChipMap(r,c);
                    if isBooleanAttr
                        temp(r,c) = logical(str2num(obj.getDeviceAttributeRAW(attr, 128, obj.iioDevices{devIndx})));
                    else
                        temp(r,c) = str2num(obj.getDeviceAttributeRAW(attr, 128, obj.iioDevices{devIndx}));
                    end
                end
            end
            if isBooleanAttr
                result = logical(temp);
            else
                result = temp;
            end
        end
        
        function setAllChipsDeviceAttributeRAW(obj, attr, values, isBooleanAttr)
%             if isBooleanAttr
%                 temp = char(ones(size(obj.SubarrayToChipMap)) * '1');
%                 for r = 1:size(values, 1)
%                     for c = 1:size(values, 2)
%                         temp(r, c) = strrep(values(r, c), ' ', '');
%                     end
%                 end
%                 values = temp;
%                 validateattributes(values, {'char'}, {'size', size(obj.deviceNames)});
%             end
            
            if obj.ConnectedToDevice
                for r = 1:size(obj.SubarrayToChipMap,1)
                    for c = 1:size(obj.SubarrayToChipMap,2)
                        devIndx = obj.SubarrayToChipMap(r,c);
                        if isBooleanAttr
                            obj.setDeviceAttributeRAW(attr, num2str(values(r,c)), obj.iioDevices{devIndx});
                        else
                            if iscell(values)
                                v = values{r,c};
                            else
                                v = values(r,c);
                            end
                            obj.setDeviceAttributeRAW(attr, num2str(v), obj.iioDevices{devIndx});
                        end
                    end
                end
            end
        end        
    end
    
    methods
        function TaperTx(obj, window, Gains, varargin)
            % TaperTx Taper Stingray Tx gain.
            % Inputs:
            %   window: Options - "none", "bartlett", "blackmann",
            %   "hamming", "hanning"
            %   Gains: Scalar/Matrix of gains in range (0-127) for the Tx VGA
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Taper("Tx", window, Gains, Offset);
        end

        function TaperRx(obj, window, Gains, varargin)
            % TaperRx Taper Stingray Rx gain.
            % Inputs:
            %   window: Options - "none", "bartlett", "blackmann",
            %   "hamming", "hanning"
            %   Gains: Scalar/Matrix of gains in range (0-127) for the Rx VGA
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Taper("Rx", window, Gains, Offset);
        end

        function SteerRx(obj, Azimuth, Elevation, varargin)
            % SteerRx Steer the Rx array in a particular direction. This method assumes that the entire array is one analog beam.
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Steer("Rx", Azimuth, Elevation, Offset);
        end
        
        function SteerTx(obj, Azimuth, Elevation, varargin)
            % SteerTx Steer the Tx array in a particular direction. This method assumes that the entire array is one analog beam.
            if (nargin == 3)
                Offset = zeros(size(obj.ArrayMapInternal));
            elseif (nargin == 4)
                Offset = varargin{1};
            end
            obj.Steer("Tx", Azimuth, Elevation, Offset)
        end
    end
    
    methods (Access = private)
        function Taper(obj, RxOrTx, window, Gains, Offset)
            rLen = size(obj.ArrayMapInternal, 1);
            cLen = size(obj.ArrayMapInternal, 2);

            switch lower(window)
                case "none"
                    rWin = ones(rLen+2);
                    cWin = ones(cLen+2);
                case "bartlett"
                    rWin = bartlett(rLen+2);
                    cWin = bartlett(cLen+2);
                case "blackman"
                    rWin = blackman(rLen+2);
                    cWin = blackman(cLen+2);
                case "hamming"
                    rWin = hamming(rLen+2);
                    cWin = hamming(cLen+2);
                case "hanning"
                    rWin = hann(rLen+2);
                    cWin = hann(cLen+2);
                case "taylor"
                    rWin = taylorwin(rLen+2);
                    cWin = taylorwin(cLen+2);
                otherwise
                    error('window type unsupported for tapering');
            end
            rWin = rWin(2:end-1);
            cWin = cWin(2:end-1);
            rWin = rWin/max(rWin);
            cWin = cWin/max(cWin);

            Array = 1:numel(obj.ArrayMapInternal);
            Array = reshape(Array, size(obj.ArrayMapInternal.')).';

            r = zeros(size(Array));
            c = zeros(size(Array));
            for ii = 1:size(obj.ArrayMapInternal, 1)
                for jj = 1:size(obj.ArrayMapInternal, 2)
                    [r(ii, jj), c(ii, jj)] = find(Array == obj.ArrayMapInternal(ii, jj));
                end
            end
            ColumnWin = cWin(c);
            RowWin = rWin(r);
            if isscalar(Gains)
                gain = Gains*ColumnWin.*RowWin;
            else
                gain = ColumnWin.*Gains.*RowWin;
            end
            gain = round(gain);

            if strcmpi(RxOrTx, 'Rx')
                obj.RxGain = gain + Offset;
                obj.LatchRxSettings();
            elseif strcmpi(RxOrTx, 'Tx')
                obj.TxGain = gain + Offset;
                obj.LatchTxSettings();
            end
        end

        function Steer(obj, RxOrTx, Azimuth, Elevation, Offset)
            [AzimuthPhi, ElevationPhi] = obj.CalculatePhi(Azimuth, Elevation);
            
            % Update the class variables
            if strcmpi(RxOrTx, 'Rx')
                obj.RxAzimuth = Azimuth;
                obj.RxElevation = Elevation;
                obj.RxAzimuthPhi = AzimuthPhi;
                obj.RxElevationPhi = ElevationPhi;
            else
                obj.TxAzimuth = Azimuth;
                obj.TxElevation = Elevation;
                obj.TxAzimuthPhi = AzimuthPhi;
                obj.TxElevationPhi = ElevationPhi;
            end
            
            % Steer the elements in the array and Latch in the new phases
            Array = 1:numel(obj.ArrayMapInternal);
            Array = reshape(Array, size(obj.ArrayMapInternal.')).';

            r = zeros(size(Array));
            c = zeros(size(Array));
            for ii = 1:size(obj.ArrayMapInternal, 1)
                for jj = 1:size(obj.ArrayMapInternal, 2)
                    [r(ii, jj), c(ii, jj)] = find(Array == obj.ArrayMapInternal(ii, jj));
                end
            end
            ColumnPhase = (c-1)*ElevationPhi;
            RowPhase = (r-1)*AzimuthPhi;
            if strcmpi(RxOrTx, 'Rx')
                obj.RxPhase = wrapTo360(ColumnPhase + RowPhase + Offset);
                obj.LatchRxSettings();
            elseif strcmpi(RxOrTx, 'Tx')
                obj.TxPhase = wrapTo360(ColumnPhase + RowPhase + Offset);
                obj.LatchTxSettings();
            end
        end
        
        function [AzPhi, ElPhi] = CalculatePhi(obj, Azimuth, Elevation)
            % CalculatePhi Calculate the Φ angles to steer the array in a particular direction.             
            % Convert the input angles to radians
            AzR = Azimuth * pi / 180;
            ElR = Elevation * pi / 180;

            % Calculate the phase increment (Φ) for each element in the array in both directions (in degrees)
            AzPhi = 2 * obj.TargetFrequency * obj.ElementSpacing * sin(AzR) * 180 / 3e8;
            ElPhi = 2 * obj.TargetFrequency * obj.ElementSpacing * sin(ElR) * 180 / 3e8;
        end
    end
    
    methods        
        function set.Mode(obj, values)
            RxEnableMat = zeros(size(obj.SubarrayToChipMap));
            TxEnableMat = zeros(size(obj.SubarrayToChipMap));

            for r = 1:size(obj.SubarrayToChipMap,1)
                for c = 1:size(obj.SubarrayToChipMap,2)
                    devIndx = obj.SubarrayToChipMap(r,c);
                    if ~(strcmpi(values{r,c}, 'Tx') || strcmpi(values{r,c}, 'Rx') ...
                             || strcmpi(values{r,c}, 'Disabled'))
                        error('Expected ''Tx'' or ''Rx'' or ''Disabled'' for property, Mode');
                    end
                    if strcmpi(values{r,c}, 'Disabled')
                        RxEnableMat(r,c) = false;
                        TxEnableMat(r,c) = false;
                    else
                        if strcmpi(values{r,c}, 'Tx')
                            RxEnableMat(r,c) = false;
                            TxEnableMat(r,c) = true;                        
                        else
                            RxEnableMat(r,c) = true;
                            TxEnableMat(r,c) = false;
                        end
                    end
                end
            end
            values_tmp = RxEnableMat>0;
            setAllChipsDeviceAttributeRAW(obj, 'rx_en', values_tmp, true);
            values_tmp = TxEnableMat>0;
            setAllChipsDeviceAttributeRAW(obj, 'tx_en', values_tmp, true);
            obj.Mode = values;
        end
                
        function set.LNABiasOutEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_out_enable', values, true);
            obj.LNABiasOutEnable = values;
        end
        
        function set.LNABiasOn(obj, values)
            dac_codes = int32(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_on', dac_codes, false);
            obj.LNABiasOn = values;
        end
        
        function set.BeamMemEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'beam_mem_enable', values, true);
            obj.BeamMemEnable = values;
        end

        function set.BiasDACEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'bias_enable', num2str(values), true);
            obj.BiasDACEnable = values;
        end
        
        function set.BiasDACMode(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'bias_ctrl', ...
                obj.CellArrayToArray(values, {'Toggle','On'}, [1,0]), true);
            obj.BiasDACMode = values;
        end

        function set.BiasMemEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'bias_mem_enable', values, true);
            obj.BiasMemEnable = values;
        end
        
        function set.CommonMemEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'common_mem_enable', values, true);
            obj.CommonMemEnable = values;
        end
        
        function set.CommonRxBeamState(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'static_rx_beam_pos_load', values, false);
            obj.CommonRxBeamState = values;
        end
        
        function set.CommonTxBeamState(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'static_tx_beam_pos_load', values, false);
            obj.CommonTxBeamState = values;
        end
        
        function set.ExternalTRPin(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_mode_sel', ...
                obj.CellArrayToArray(obj.ExternalTRPin, {'Pos','Neg'}, [0,1]), true);
            obj.ExternalTRPin = values;
        end
        
        function set.ExternalTRPolarity(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_state', (values), true);
            obj.ExternalTRPolarity = values;
        end
        
        function set.LNABiasOff(obj, values)
            dac_codes = int32(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_off', dac_codes, false);
            obj.LNABiasOff = values;
        end
        
        function set.PolState(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'pol', values, true);
            obj.PolState = values;
        end
        
        function set.PolSwitchEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_pol', values, true);
            obj.PolSwitchEnable = values;
        end
        
        function set.RxLNABiasCurrent(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx_lna', values, false);
            obj.RxLNABiasCurrent = values;
        end
        
        function set.RxLNAEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'rx_lna_enable', num2str(values), true);
            obj.RxLNAEnable = values;
        end
        
        function set.RxToTxDelay1(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_1', values, false);
            obj.RxToTxDelay1 = values;
        end
        
        function set.RxToTxDelay2(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_2', values, false);
            obj.RxToTxDelay2 = values;
        end
        
        function set.RxVGAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_vga_enable', values, true);
            obj.RxVGAEnable = values;
        end
        
        function set.RxVGABiasCurrentVM(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx', values, false);
            obj.RxVGABiasCurrentVM = values;
        end
        
        function set.RxVMEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_vm_enable', values, true);
            obj.RxVMEnable = values;
        end
        
        function set.SequencerEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'sequencer_enable', values, true);
            obj.SequencerEnable = values;
        end
        
        function set.TRSwitchEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_tr', values, true);
            obj.TRSwitchEnable = values;
        end
        
        function set.TxPABiasCurrent(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx_drv', values, false);
            obj.TxPABiasCurrent = values;
        end
        
        function set.TxPAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_drv_enable', values, true);
            obj.TxPAEnable = values;
        end
        
        function set.TxToRxDelay1(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_1', values, false);
            obj.TxToRxDelay1 = values;
        end
        
        function set.TxToRxDelay2(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_2', values, false);
            obj.TxToRxDelay2 = values;
        end
        
        function set.TxVGAEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'tx_vga_enable', values, true);
            obj.TxVGAEnable = values;
        end
        
        function set.TxVGABiasCurrentVM(obj, values)
            values = int32(values);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx', values, false);
            obj.TxVGABiasCurrentVM = values;
        end
        
        function set.TxVMEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_vm_enable', values, true);
            obj.TxVMEnable = values;
        end
        
        function set.TxRxSwitchControl(obj, values)
            bvalues = false(size(values));
            for i = 1:numel(values)
                bvalues(i) = strcmpi(values{i},'external');
            end
            obj.setAllChipsDeviceAttributeRAW('tr_source', bvalues, true);
            obj.TxRxSwitchControl = values;
        end

        function Reset(obj)
            values = true(size(obj.SubarrayToChipMap));
            setAllChipsDeviceAttributeRAW(obj, 'reset', values, true);
        end
        
        function Initialize(obj, PAOff, PAOn, LNAOff, LNAOn)
            % Put the part in a known state
            obj.Reset();
            
            % Set the bias currents to nominal
            obj.RxLNABiasCurrent = hex2dec('0x08')*ones(size(obj.SubarrayToChipMap));
            obj.RxVGABiasCurrentVM = hex2dec('0x55')*ones(size(obj.SubarrayToChipMap));
            obj.TxVGABiasCurrentVM = hex2dec('0x2D')*ones(size(obj.SubarrayToChipMap));
            obj.TxPABiasCurrent = hex2dec('0x06')*ones(size(obj.SubarrayToChipMap));
            
            % Disable RAM control
            obj.BeamMemEnable = false(size(obj.SubarrayToChipMap));
            obj.BiasMemEnable = false(size(obj.SubarrayToChipMap));
            obj.CommonMemEnable = false(size(obj.SubarrayToChipMap));
            
            % Enable all internal amplifiers
            obj.RxVGAEnable = true(size(obj.SubarrayToChipMap)); 
            obj.RxVMEnable = true(size(obj.SubarrayToChipMap));
            obj.RxLNAEnable = true(size(obj.SubarrayToChipMap));
            obj.TxVGAEnable = true(size(obj.SubarrayToChipMap));
            obj.TxVMEnable = true(size(obj.SubarrayToChipMap));
            obj.TxPAEnable = true(size(obj.SubarrayToChipMap));
            
            % Disable Tx/Rx paths for the device
            TempMode = cell(size(obj.SubarrayToChipMap));
            TempMode(:) = {'disabled'};
            obj.Mode = TempMode;

            % Enable the PA/LNA bias DACs
            obj.LNABiasOutEnable = true(size(obj.SubarrayToChipMap));
            obj.BiasDACEnable = true(size(obj.SubarrayToChipMap));
            TempBiasDACMode = cell(size(obj.SubarrayToChipMap));
            TempBiasDACMode(:) = {'Toggle'};
            obj.BiasDACMode = TempBiasDACMode;
            
            % Configure the external switch control
            obj.ExternalTRPolarity = true(size(obj.SubarrayToChipMap));
            obj.TRSwitchEnable = true(size(obj.SubarrayToChipMap));

            % Set the default LNA bias
            obj.LNABiasOff = LNAOff*ones(size(obj.SubarrayToChipMap));
            obj.LNABiasOn = LNAOn*ones(size(obj.SubarrayToChipMap));
            
            % Default channel enable
            obj.RxPowerDown = zeros(size(obj.ElementToChipChannelMap));
            obj.TxPowerDown = zeros(size(obj.ElementToChipChannelMap));

            % Default PA bias
            obj.PABiasOff = PAOff*ones(size(obj.ElementToChipChannelMap));
            obj.PABiasOn = PAOn*ones(size(obj.ElementToChipChannelMap));

            % Default attenuator, gain, and phase
            obj.RxAttn = false(size(obj.ElementToChipChannelMap));
            obj.RxGain = hex2dec('0x7F')*ones(size(obj.ElementToChipChannelMap));
            obj.RxPhase = zeros(size(obj.ElementToChipChannelMap));
            obj.TxAttn = false(size(obj.ElementToChipChannelMap));
            obj.TxGain = hex2dec('0x7F')*ones(size(obj.ElementToChipChannelMap));
            obj.TxPhase = zeros(size(obj.ElementToChipChannelMap));
            
            % Latch in the new settings
            obj.LatchRxSettings();
            obj.LatchTxSettings();
        end
    end
    
    methods
        function LatchRxSettings(obj)
            setAllChipsDeviceAttributeRAW(obj, 'rx_load_spi', (true(size(obj.SubarrayToChipMap))), true);
        end
        
        function LatchTxSettings(obj)
            setAllChipsDeviceAttributeRAW(obj, 'tx_load_spi', (true(size(obj.SubarrayToChipMap))), true);
        end
    end
    
    % Get/Set Methods for Channel Attributes
    methods
        function set.DetectorEnable(obj, values)
            setAllChipsChannelAttribute(obj, values, 'detector_en', true, 'logical');
            obj.DetectorEnable = values;
        end
        
        function result = get.DetectorPower(obj)
            result = zeros(size(obj.ElementToChipChannelMap));
            if ~isempty(obj.iioDevices)
                obj.DetectorEnable = true(size(obj.ElementToChipChannelMap));
                result = getAllChipsChannelAttribute(obj, 'raw', true, 'raw');
                obj.DetectorEnable = false(size(obj.ElementToChipChannelMap));
            end
        end
        
        function set.PABiasOff(obj, values)
            dac_codes = int64(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsChannelAttribute(obj, dac_codes, 'pa_bias_off', true, 'int64');
            obj.PABiasOff = values;
        end
        
        function set.PABiasOn(obj, values)
            dac_codes = int64(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsChannelAttribute(obj, dac_codes, 'pa_bias_on', true, 'int32');
            obj.PABiasOn = values;
        end
                
        function set.RxAttn(obj, values)
            setAllChipsChannelAttribute(obj, values, 'attenuation', false, 'logical');
            obj.RxAttn = values;
        end
        
        function set.RxBeamState(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'RxBeamState');
            setAllChipsChannelAttribute(obj, values, 'beam_pos_load', false, 'int32');
            obj.RxBeamState = values;
        end
        
        function set.RxPowerDown(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'powerdown', false, 'logical');
            obj.RxPowerDown = values;
        end

        function set.RxGain(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'RxGain');
            setAllChipsChannelAttribute(obj, values, 'hardwaregain', false, 'double', 128);
            obj.RxGain = values;
        end
        
        function set.RxPhase(obj, values)
            validateattributes( values, { 'double'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','>=',0,'<=',360}, ...
                '', 'RxPhase');
            for ii = 1:size(values, 1)
                for jj = 1:size(values, 2)
                    if (values(ii, jj) > 357)
                        values(ii, jj) = 0;
                    end
                end
            end
            setAllChipsChannelAttribute(obj, values, 'phase', false, 'double', 4);
            obj.RxPhase = values;
        end
        
        function set.TxAttn(obj, values)
            setAllChipsChannelAttribute(obj, values, 'attenuation', true, 'logical');
            obj.TxAttn = values;
        end
        
        function set.TxBeamState(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'TxBeamState');
            setAllChipsChannelAttribute(obj, values, 'beam_pos_load', true, 'int32');
            obj.TxBeamState = values;
        end
        
        function set.TxPowerDown(obj, values)
            obj.verifySizing(values, obj.ElementToChipChannelMap, 'TxPowerDown');
            setAllChipsChannelAttribute(obj, ~values, 'powerdown', true, 'logical');
            obj.TxPowerDown = values;
        end
        
        function set.TxGain(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'TxGain');
            obj.verifySizing(values, obj.ElementToChipChannelMap, 'TxGain');
            setAllChipsChannelAttribute(obj, values, 'hardwaregain', true, 'double', 128);
            obj.TxGain = values;
        end
        
        function set.TxPhase(obj, values)
            validateattributes( values, { 'double'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','>=',0,'<=',360}, ...
                '', 'TxPhase');
                obj.verifySizing(values, obj.ElementToChipChannelMap, 'TxPhase');
                for ii = 1:size(values, 1)
                for jj = 1:size(values, 2)
                    if (values(ii, jj) > 357)
                        values(ii, jj) = 0;
                    end
                end
            end
            setAllChipsChannelAttribute(obj, values, 'phase', true, 'double', 4);
            obj.TxPhase = values;
        end
        
%         function result = get.RxBiasState(obj)
%             result = zeros(size(obj.ElementToChipChannelMap));
%             if ~isempty(obj.iioDevices)
%                 result = getAllChipsChannelAttribute(obj, 'bias_set_load', false, 'logical');
%             end
%         end
%         
%         function set.RxBiasState(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'bias_set_load', false, 'logical');
%         end
        
        function set.RxSequencerStart(obj, values)
            setAllChipsChannelAttribute(obj, values, 'sequence_start', false, 'logical');
            obj.RxSequencerStart = values;
        end
        
        function set.RxSequencerStop(obj, values)
            setAllChipsChannelAttribute(obj, values, 'sequence_end', false, 'logical');
            obj.RxSequencerStop = values;
        end
        
%         function result = get.TxBiasState(obj)
%             result = zeros(size(obj.ElementToChipChannelMap));
%             if ~isempty(obj.iioDevices)
%                 result = ~getAllChipsChannelAttribute(obj, 'bias_set_load', true, 'logical');
%             end
%         end
%         
%         function set.TxBiasState(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'bias_set_load', true, 'logical');
%         end
        
        function set.TxSequencerStart(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'sequence_start', true, 'logical');
            obj.TxSequencerStart = values;
        end
        
        function set.TxSequencerStop(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'sequence_end', true, 'logical');
            obj.TxSequencerStop = values;
        end
        
        function result = get.Temp(obj)
            result = zeros(size(obj.SubarrayToChipMap));
            if ~isempty(obj.iioDevices)
                    result = obj.getAllChipsDeviceAttributeRAW('temp0', false);
            end
        end
    end
    
    methods    
        function SaveRxBeam(obj, ChipIDIndx, ChIndx, State, Attn, Gain, Phase)
             validateattributes( State, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'State');
             validateattributes( Gain, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'Gain');             
            obj.setAttributeRAW(sprintf('voltage%d', ChIndx), ...
                'beam_pos_save', sprintf('%d, %d, %d, %f', State, Attn, Gain, Phase), false, obj.iioDevices{ChipIDIndx});
        end
        
        function SaveTxBeam(obj, ChipIDIndx, ChIndx, State, Attn, Gain, Phase)
             validateattributes( State, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'State');
             validateattributes( Gain, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'Gain');             
            obj.setAttributeRAW(sprintf('voltage%d', ChIndx), ...
                'beam_pos_save', sprintf('%d, %d, %d, %f', State, Attn, Gain, Phase), true, obj.iioDevices{ChipIDIndx});
        end
    end
    
    methods (Hidden, Access = protected)
        function setupInit(obj)
            numDevs = obj.iio_context_get_devices_count(obj.iioCtx);
            obj.iioDevices = cell(1,length(obj.deviceNames));
            for dn = 1:length(obj.deviceNames)
                for k = 1:numDevs
                    devPtr = obj.iio_context_get_device(obj.iioCtx, k-1);
                    name = obj.iio_device_get_name(devPtr);
                    if strcmpi(obj.deviceNames{dn},name)
                        obj.iioDevices{dn} = devPtr;
                    end
                end
                if isempty(obj.iioDevices{dn})
                   error('%s not found',obj.deviceNames{dn});
                end
            end

            if obj.SkipInit
                return;
            end

            % Write device attributes
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_out_enable', obj.LNABiasOutEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_on', int32(obj.LNABiasOn / obj.BIAS_CODE_TO_VOLTAGE_SCALE), false);
            values = obj.Mode;
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Tx') || strcmpi(values(ii), 'Rx'))
                    error('Expected ''Tx'' or ''Rx'' for property, Mode');
                end
                if strcmpi(values(ii), 'Tx')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'tr_spi', ivalues, true);
            setAllChipsDeviceAttributeRAW(obj, 'beam_mem_enable', obj.BeamMemEnable, true);

            setAllChipsDeviceAttributeRAW(obj, 'bias_ctrl', obj.CellArrayToArray(obj.BiasDACMode, {'Toggle','On'}, [1,0]), true);
            setAllChipsDeviceAttributeRAW(obj, 'common_mem_enable', obj.CommonMemEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'static_rx_beam_pos_load', int32(obj.CommonRxBeamState), false);
            setAllChipsDeviceAttributeRAW(obj, 'static_tx_beam_pos_load', int32(obj.CommonTxBeamState), false);

            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_mode_sel', obj.CellArrayToArray(obj.ExternalTRPin, {'Pos','Neg'}, [0,1]), true);
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_state', obj.ExternalTRPolarity, true);
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_off', int32(obj.LNABiasOff / obj.BIAS_CODE_TO_VOLTAGE_SCALE), false);
            setAllChipsDeviceAttributeRAW(obj, 'pol', obj.PolState, true);
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_pol', obj.PolSwitchEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx_lna', int32(obj.RxLNABiasCurrent), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_lna_enable', obj.RxLNAEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_1', int32(obj.RxToTxDelay1), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_2', int32(obj.RxToTxDelay2), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_vga_enable', obj.RxVGAEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx', int32(obj.RxVGABiasCurrentVM), false);
            setAllChipsDeviceAttributeRAW(obj, 'rx_vm_enable', obj.RxVMEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'sequencer_enable', obj.SequencerEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_tr', obj.TRSwitchEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx_drv', int32(obj.TxPABiasCurrent), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_drv_enable', obj.TxPAEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_1', int32(obj.TxToRxDelay1), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_2', int32(obj.TxToRxDelay2), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_vga_enable', obj.TxVGAEnable, true);
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx', int32(obj.TxVGABiasCurrentVM), false);
            setAllChipsDeviceAttributeRAW(obj, 'tx_vm_enable', obj.TxVMEnable, true);

            % Write channel attributes
            setAllChipsChannelAttribute(obj, int64(obj.PABiasOff / obj.BIAS_CODE_TO_VOLTAGE_SCALE), 'pa_bias_off', true, 'int64');
            setAllChipsChannelAttribute(obj, int64(obj.PABiasOn / obj.BIAS_CODE_TO_VOLTAGE_SCALE), 'pa_bias_on', true, 'int32');
            setAllChipsChannelAttribute(obj, obj.RxAttn, 'attenuation', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.RxBeamState, 'beam_pos_load', false, 'int32');
            setAllChipsChannelAttribute(obj, ~obj.RxPowerDown, 'powerdown', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.RxGain, 'hardwaregain', false, 'double', 128);warning('FIXME LATER')
            setAllChipsChannelAttribute(obj, obj.RxPhase, 'phase', false, 'double', 4);
            setAllChipsChannelAttribute(obj, obj.TxAttn, 'attenuation', true, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxBeamState, 'beam_pos_load', true, 'int32');
            setAllChipsChannelAttribute(obj, ~obj.TxPowerDown, 'powerdown', true, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxGain, 'hardwaregain', true, 'double',128);warning('FIXME LATER')
            setAllChipsChannelAttribute(obj, obj.TxPhase, 'phase', true, 'double', 4);
            setAllChipsChannelAttribute(obj, obj.RxSequencerStart, 'sequence_start', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.RxSequencerStop, 'sequence_end', false, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxSequencerStart, 'sequence_start', true, 'logical');
            setAllChipsChannelAttribute(obj, obj.TxSequencerStop, 'sequence_end', true, 'logical');

            % Latch settings
            obj.LatchRxSettings();
            obj.LatchTxSettings();
        end
        
        function setupImpl(obj)
            setupLib(obj);
            initPointers(obj);
            getContext(obj);
            setContextTimeout(obj);
            obj.needsTeardown = true;
            obj.ConnectedToDevice = true;
            setupInit(obj);
        end
        
        function [data,valid] = stepImpl(~)
            data = 0;
            valid = false;
        end
    end

    methods (Static)

        function outArray = CellArrayToArray(inCell, strings, values)
            outArray = zeros(size(inCell));
            for r = 1:size(inCell, 1)
                for c = 1:size(inCell, 2)
                    % Lookup value
                    for i = 1:length(strings)
                        if strcmp(inCell{r,c}, strings{i})
                            outArray(r,c) = values(i);
                            break;
                        end
                    end
                end
            end
        end

        function verifySizing(inArray, expected, propName)
            if ~isequal(size(inArray), size(expected))
                error('%s must be of size [%dx%d]', propName, ...
                    size(expected,1), size(expected,2));
            end
        end

    end
end
