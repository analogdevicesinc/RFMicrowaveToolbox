classdef (Abstract) ADAR100x < adi.common.Attribute & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties (Constant, Hidden)
        BIAS_CODE_TO_VOLTAGE_SCALE = -0.018824
    end
    
    properties(Abstract, Nontunable, Hidden)
        ArrayMapInternal
        deviceNames
    end
    
    properties(Nontunable, Hidden)
        kernelBuffersCount = 0;
        dataTypeStr = 'int16';
        iioDriverName = 'adar1000';
        devName = 'adar1000';
        SamplesPerFrame = 0;
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
        % Device Attributes
        Mode = {'Rx'}
        StateTxOrRx = {'Rx'}
        RxEnable = true
        TxEnable = false
        LNABiasOutEnable = true
        LNABiasOn = -4.80012
        BeamMemEnable = true
        % BiasDACEnable = true
        BiasDACMode = {'On'}
        % BiasMemEnable = true
        CommonMemEnable = true
        CommonRxBeamState = 0
        CommonTxBeamState = 0
        ExternalTRPin = {'Pos'}
        ExternalTRPolarity = false
        LNABiasOff = -4.80012
        PolState = false
        PolSwitchEnable = false
        RxLNABiasCurrent = 0
        RxLNAEnable = false
        RxToTxDelay1 = 0
        RxToTxDelay2 = 0
        RxVGAEnable = false
        RxVGABiasCurrentVM = 0
        RxVMEnable = false
        SequencerEnable = false
        TRSwitchEnable = false
        TxPABiasCurrent = 0
        TxPAEnable = false
        TxToRxDelay1 = 0
        TxToRxDelay2 = 0
        TxVGAEnable = false
        TxVGABiasCurrentVM = 0
        TxVMEnable = false
        
        % Channel Attributes
        % DetectorEnable = true(1, 4)
        % DetectorPower = 255*ones(1, 4)
        PABiasOff = -4.80012*ones(1, 4)
        PABiasOn = -4.80012*ones(1, 4)
        RxAttn = true(1, 4)
        RxBeamState = zeros(1, 4)
        RxPowerDown = false(1, 4)
        % RxGain = ones(1, 4)
        RxPhase = zeros(1, 4)
        TxAttn = true(1, 4)
        TxBeamState = zeros(1, 4)
        TxPowerDown = false(1, 4)
        % TxGain = ones(1, 4)
        TxPhase = zeros(1, 4)
        % RxBiasState = zeros(1, 4)
        RxSequencerStart = false(1, 4)
        RxSequencerStop = false(1, 4)
        % TxBiasState = zeros(1, 4)
        TxSequencerStart = false(1, 4)
        TxSequencerStop = false(1, 4)
        Temp = 0
    end
    
    methods
        % Constructor
        function obj = ADAR100x(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
            % Check that the number of chips matches for all the inputs
            if ((numel(obj.deviceNames)*4) ~= numel(obj.ArrayMapInternal))
                error('Expected equal number of elements in ArrayMapInternal and 4*numel(ChipIDs)');
            end
        end
        
        % Destructor
        function delete(obj)
        end
        
        function result = getAllChipsChannelAttribute(obj, attr, isOutput, AttrClass)
            if strcmpi(AttrClass, 'logical')
                result = false(size(obj.ArrayMapInternal));
            elseif strcmpi(AttrClass, 'raw')
                result = zeros(size(obj.ArrayMapInternal));
            elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                result = zeros(size(obj.ArrayMapInternal));
            elseif strcmpi(AttrClass, 'double')
                result = zeros(size(obj.ArrayMapInternal));
            end
            for d = 1:numel(obj.iioDevices)
                for c = 0:3
                    channel = sprintf('voltage%d', c);
                    if strcmpi(AttrClass, 'logical')
                        result(d, c+1) = obj.getAttributeBool(channel, attr, isOutput, obj.iioDevices{d});
                    elseif strcmpi(AttrClass, 'raw')
                        result(d, c+1) = str2double(obj.getAttributeRAW(channel, attr, isOutput, obj.iioDevices{d}));
                    elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                        result(d, c+1) = obj.getAttributeLongLong(channel, attr, isOutput, obj.iioDevices{d});
                    elseif strcmpi(AttrClass, 'double')
                        result(d, c+1) = obj.getAttributeDouble(channel, attr, isOutput, obj.iioDevices{d});
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
                    {'size', size(obj.ArrayMapInternal)});
            elseif strcmpi(AttrClass, 'raw') || ...
                    strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                validateattributes(values, {'numeric', 'uint32'},...
                    {'size', size(obj.ArrayMapInternal)});
            elseif strcmpi(AttrClass, 'double')
                validateattributes(values, {'numeric', 'double'},...
                    {'size', size(obj.ArrayMapInternal)});
            end
            
            if obj.ConnectedToDevice
                for dev = 1:numel(obj.deviceNames)
                    for ch = 1:4
                        channel = sprintf('voltage%d', ch-1);
                        if strcmpi(AttrClass, 'logical')
                            obj.setAttributeBool(channel, attr, ...
                                values(dev, ch), isOutput, obj.iioDevices{dev});
                        elseif strcmpi(AttrClass, 'raw')
                            obj.setAttributeRAW(channel, attr, ...
                                values(dev, ch), isOutput, obj.iioDevices{dev});
                        elseif strcmpi(AttrClass, 'int32') || strcmpi(AttrClass, 'int64')
                            obj.setAttributeLongLong(channel, attr, ...
                                values(dev, ch), isOutput, Tol, obj.iioDevices{dev});
                        elseif strcmpi(AttrClass, 'double')
                            obj.setAttributeDouble(channel, attr, ...
                                values(dev, ch), isOutput, Tol, obj.iioDevices{dev});
                        end
                    end
                end
            end
        end
        
        function result = getAllChipsDeviceAttributeRAW(obj, attr, isBooleanAttr)
            if isBooleanAttr
                temp = false(size(obj.deviceNames));
            else
                temp = zeros(size(obj.deviceNames));
            end
            for ii = 1:numel(obj.deviceNames)
                if isBooleanAttr
                    temp(ii) = logical(str2num(obj.getDeviceAttributeRAW(attr, 128, obj.iioDevices{ii})));
                else
                    temp(ii) = str2num(obj.getDeviceAttributeRAW(attr, 128, obj.iioDevices{ii}));
                end
            end
            if isBooleanAttr
                result = logical(temp);
            else
                result = temp;
            end
        end
        
        function setAllChipsDeviceAttributeRAW(obj, attr, values, isBooleanAttr)
            if isBooleanAttr
                temp = char(ones(size(obj.deviceNames)) * '1');
                for ii = 1:size(values, 1)
                    temp(ii, :) = strrep(values(ii, :), ' ', '');
                end
                values = temp;
                validateattributes(values, {'char'}, {'size', size(obj.deviceNames)});
            end
            
            if obj.ConnectedToDevice
                for ii = 1:numel(obj.deviceNames)
                    if isBooleanAttr
                        obj.setDeviceAttributeRAW(attr, values(ii), obj.iioDevices{ii});
                    else
                        obj.setDeviceAttributeRAW(attr, values{ii}, obj.iioDevices{ii});
                    end
                end
            end
        end        
    end
    
    methods
        function result = get.Mode(obj)
            result = cell(size(obj.deviceNames));
            result(:) = {'Rx'};
            RxEnableMat = obj.RxEnable;
            TxEnableMat = obj.TxEnable;
            StateTxOrRxMat = obj.StateTxOrRx;
            if ~isempty(obj.iioDevices)
                for ii = 1:numel(obj.deviceNames)
                    if (RxEnableMat(ii) && ~TxEnableMat(ii))
                        if strcmp(StateTxOrRxMat(ii), 'Rx')
                            result(ii) = {'Rx'};
                        else
                            result(ii) = {'Disabled'};
                        end
                    elseif (TxEnableMat(ii) && ~RxEnableMat(ii))
                        if strcmp(StateTxOrRxMat(ii), 'Tx')
                            result(ii) = {'Tx'};
                        else
                            result(ii) = {'Disabled'};
                        end
                    elseif (TxEnableMat(ii) && RxEnableMat(ii))
                        result(ii) = StateTxOrRxMat(ii);
                    else
                        result(ii) = {'Disabled'};
                    end
                end
            end
        end
        
        function set.Mode(obj, values)
            RxEnableMat = char(ones(size(values)) * '0');
            TxEnableMat = char(ones(size(values)) * '0');
            StateTxOrRxMat = cell(size(values));
            StateTxOrRxMat(:) = {'Rx'};
            for ii = 1:numel(values)
                if ~(strcmpi(values{ii}, 'Tx') || strcmpi(values{ii}, 'Rx') ...
                         || strcmpi(values{ii}, 'Disabled'))
                    error('Expected ''Tx'' or ''Rx'' or ''Disabled'' for property, Mode');
                end
                if strcmpi(values{ii}, 'Disabled')
                    RxEnableMat(ii) = '0';
                    TxEnableMat(ii) = '0';
                else
                    StateTxOrRxMat{ii} = values{ii};
                    if strcmpi(values(ii), 'Tx')
                        RxEnableMat(ii) = '0';
                        TxEnableMat(ii) = '1';                        
                    else
                        RxEnableMat(ii) = '1';
                        TxEnableMat(ii) = '0';
                    end
                end
            end
            obj.RxEnable = RxEnableMat;
            obj.TxEnable = TxEnableMat;
            obj.StateTxOrRx = StateTxOrRxMat;
        end
        
        function result = get.RxEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'rx_en', true);
            end
        end
        
        function set.RxEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'rx_en', num2str(values), true);
        end
        
        function result = get.TxEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'tx_en', true);
            end
        end
        
        function set.TxEnable(obj, values)
            setAllChipsDeviceAttributeRAW(obj, 'tx_en', num2str(values), true);
        end
        
        function result = get.LNABiasOutEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'lna_bias_out_enable', true);
            end
        end
        
        function set.LNABiasOutEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_out_enable', num2str(values), true);
        end
        
        function result = get.LNABiasOn(obj)
            result = 255*obj.BIAS_CODE_TO_VOLTAGE_SCALE*ones(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'lna_bias_on', false);
                result = obj.BIAS_CODE_TO_VOLTAGE_SCALE*result;
            end            
        end
        
        function set.LNABiasOn(obj, values)
            dac_codes = int32(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            dac_codes = convertStringsToChars(string(dac_codes));
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_on', dac_codes, false);
        end
        
        function result = get.StateTxOrRx(obj)
            result = cell(size(obj.deviceNames));
            result(:) = {'Rx'};
            if ~isempty(obj.iioDevices)
                temp = getAllChipsDeviceAttributeRAW(obj,'tr_spi', true);
                for ii = 1:numel(temp)
                    if temp(ii)
                        result(ii) = {'Tx'};
                    else
                        result(ii) = {'Rx'};
                    end
                end
            end
        end
        
        function set.StateTxOrRx(obj, values)
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Tx') || strcmpi(values(ii), 'Rx'))
                    error('Expected ''Tx'' or ''Rx'' for property, StateTxOrRx');
                end
                if strcmpi(values(ii), 'Tx')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'tr_spi', ivalues, true);
        end
        
        function result = get.BeamMemEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'beam_mem_enable', true);
            end
        end
        
        function set.BeamMemEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'beam_mem_enable', num2str(values), true);
        end
        
%         function result = get.BiasDACEnable(obj)
%             result = true(size(obj.deviceNames));
%             if ~isempty(obj.iioDevices)
%                 result = ~getAllChipsDeviceAttributeRAW(obj,'bias_enable', true);
%             end
%         end
%         
%         function set.BiasDACEnable(obj, values)            
%             setAllChipsDeviceAttributeRAW(obj, 'bias_enable', num2str(values), true);
%         end
        
        function result = get.BiasDACMode(obj)
            result = cell(size(obj.deviceNames));
            result(:) = {'On'};
            if ~isempty(obj.iioDevices)
                temp = getAllChipsDeviceAttributeRAW(obj,'bias_ctrl', true);
                for ii = 1:numel(temp)
                    if temp(ii)
                        result(ii) = {'Toggle'};
                    else
                        result(ii) = {'On'};
                    end
                end
            end
        end
        
        function set.BiasDACMode(obj, values)
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Toggle') || strcmpi(values(ii), 'On'))
                    error('Expected ''Toggle'' or ''On'' for property, BiasDACMode');
                end
                if strcmpi(values(ii), 'Toggle')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'bias_ctrl', ivalues, true);
        end
        
%         function result = get.BiasMemEnable(obj)
%             result = true(size(obj.deviceNames));
%             if ~isempty(obj.iioDevices)
%                 result = getAllChipsDeviceAttributeRAW(obj,'bias_mem_enable', true);
%             end
%         end
%         
%         function set.BiasMemEnable(obj, values)            
%             setAllChipsDeviceAttributeRAW(obj, 'bias_mem_enable', num2str(values), true);
%         end
        
        function result = get.CommonMemEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'common_mem_enable', true);
            end
        end
        
        function set.CommonMemEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'common_mem_enable', num2str(values), true);
        end
        
        function result = get.CommonRxBeamState(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'static_rx_beam_pos_load', false);
            end            
        end
        
        function set.CommonRxBeamState(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'static_rx_beam_pos_load', values, false);
        end
        
        function result = get.CommonTxBeamState(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'static_tx_beam_pos_load', false);
            end            
        end
        
        function set.CommonTxBeamState(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'static_tx_beam_pos_load', values, false);
        end
        
        function result = get.ExternalTRPin(obj)
            result = cell(size(obj.deviceNames));
            result(:) = {'Pos'};
            if ~isempty(obj.iioDevices)
                temp = getAllChipsDeviceAttributeRAW(obj,'sw_drv_tr_mode_sel', true);
                for ii = 1:numel(temp)
                    if temp(ii)
                        result(ii) = {'Neg'};
                    else
                        result(ii) = {'Pos'};
                    end
                end
            end
        end
        
        function set.ExternalTRPin(obj, values)
            ivalues = char(ones(size(values)) * '0');
            for ii = 1:numel(values)
                if ~(strcmpi(values(ii), 'Pos') || strcmpi(values(ii), 'Neg'))
                    error('Expected ''Pos'' or ''Neg'' for property, ExternalTRPin');
                end
                if strcmpi(values(ii), 'Neg')
                    ivalues(ii) = '1';
                else
                    ivalues(ii) = '0';
                end
            end
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_mode_sel', ivalues, true);
        end
        
        function result = get.ExternalTRPolarity(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'sw_drv_tr_state', true);
            end
        end
        
        function set.ExternalTRPolarity(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_tr_state', num2str(values), true);
        end
        
        function result = get.LNABiasOff(obj)
            result = 255*obj.BIAS_CODE_TO_VOLTAGE_SCALE*ones(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'lna_bias_off', false);
                result = obj.BIAS_CODE_TO_VOLTAGE_SCALE*result;
            end            
        end
        
        function set.LNABiasOff(obj, values)
            dac_codes = int32(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            dac_codes = convertStringsToChars(string(dac_codes));
            setAllChipsDeviceAttributeRAW(obj, 'lna_bias_off', dac_codes, false);
        end
        
        function result = get.PolState(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'pol', true);
            end
        end
        
        function set.PolState(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'pol', num2str(values), true);
        end
        
        function result = get.PolSwitchEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'sw_drv_en_pol', true);
            end
        end
        
        function set.PolSwitchEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_pol', num2str(values), true);
        end
        
        function result = get.RxLNABiasCurrent(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj, 'bias_current_rx_lna', false);
            end            
        end
        
        function set.RxLNABiasCurrent(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx_lna', values, false);
        end
        
        function result = get.RxLNAEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'rx_lna_enable', true);
            end
        end
        
        function set.RxLNAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_lna_enable', num2str(values), true);
        end
        
        function result = get.RxToTxDelay1(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'rx_to_tx_delay_1', false);
            end            
        end
        
        function set.RxToTxDelay1(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_1', values, false);
        end
        
        function result = get.RxToTxDelay2(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'rx_to_tx_delay_2', false);
            end            
        end
        
        function set.RxToTxDelay2(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'rx_to_tx_delay_2', values, false);
        end
        
        function result = get.RxVGAEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'rx_vga_enable', true);
            end
        end
        
        function set.RxVGAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_vga_enable', num2str(values), true);
        end
        
        function result = get.RxVGABiasCurrentVM(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'bias_current_rx', false);
            end            
        end
        
        function set.RxVGABiasCurrentVM(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_rx', values, false);
        end
        
        function result = get.RxVMEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'rx_vm_enable', true);
            end
        end
        
        function set.RxVMEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'rx_vm_enable', num2str(values), true);
        end
        
        function result = get.SequencerEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'sequencer_enable', true);
            end
        end
        
        function set.SequencerEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sequencer_enable', num2str(values), true);
        end
        
        function result = get.TRSwitchEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_tr', true);
            end
        end
        
        function set.TRSwitchEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'sw_drv_en_tr', num2str(values), true);
        end
        
        function result = get.TxPABiasCurrent(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj, 'bias_current_tx_drv', false);
            end            
        end
        
        function set.TxPABiasCurrent(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx_drv', values, false);
        end
        
        function result = get.TxPAEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj, 'tx_drv_enable', true);
            end
        end
        
        function set.TxPAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_drv_enable', num2str(values), true);
        end
        
        function result = get.TxToRxDelay1(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'tx_to_rx_delay_1', false);
            end            
        end
        
        function set.TxToRxDelay1(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_1', values, false);
        end
        
        function result = get.TxToRxDelay2(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'tx_to_rx_delay_2', false);
            end            
        end
        
        function set.TxToRxDelay2(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'tx_to_rx_delay_2', values, false);
        end
        
        function result = get.TxVGAEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'tx_vga_enable', true);
            end
        end
        
        function set.TxVGAEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_vga_enable', num2str(values), true);
        end
        
        function result = get.TxVGABiasCurrentVM(obj)
            result = zeros(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'bias_current_tx', false);
            end            
        end
        
        function set.TxVGABiasCurrentVM(obj, values)
            values = int32(values);
            values = convertStringsToChars(string(values));
            setAllChipsDeviceAttributeRAW(obj, 'bias_current_tx', values, false);
        end
        
        function result = get.TxVMEnable(obj)
            result = true(size(obj.deviceNames));
            if ~isempty(obj.iioDevices)
                result = getAllChipsDeviceAttributeRAW(obj,'tx_vm_enable', true);
            end
        end
        
        function set.TxVMEnable(obj, values)            
            setAllChipsDeviceAttributeRAW(obj, 'tx_vm_enable', num2str(values), true);
        end
        
        function Reset(obj)
            values = true(size(obj.deviceNames));
            setAllChipsDeviceAttributeRAW(obj, 'reset', num2str(values), true);
        end
        
        function Initialize(obj, PAOff, PAOn, LNAOff, LNAOn)
            % Put the part in a known state
            obj.Reset();
            
            % Set the bias currents to nominal
            obj.RxLNABiasCurrent = hex2dec('0x08')*ones(size(obj.deviceNames));
            obj.RxVGABiasCurrentVM = hex2dec('0x55')*ones(size(obj.deviceNames));
            obj.TxVGABiasCurrentVM = hex2dec('0x2D')*ones(size(obj.deviceNames));
            obj.TxPABiasCurrent = hex2dec('0x06')*ones(size(obj.deviceNames));
            
            % Disable RAM control
            obj.BeamMemEnable = false(size(obj.deviceNames));
            obj.BiasMemEnable = false(size(obj.deviceNames));
            obj.CommonMemEnable = false(size(obj.deviceNames));
            
            % Enable all internal amplifiers
            obj.RxVGAEnable = true(size(obj.deviceNames)); 
            obj.RxVMEnable = true(size(obj.deviceNames));
            obj.RxLNAEnable = true(size(obj.deviceNames));
            obj.TxVGAEnable = true(size(obj.deviceNames));
            obj.TxVMEnable = true(size(obj.deviceNames));
            obj.TxPAEnable = true(size(obj.deviceNames));
            
            % Disable Tx/Rx paths for the device
            TempMode = cell(size(obj.deviceNames));
            TempMode(:) = {'disabled'};
            obj.Mode = TempMode;

            % Enable the PA/LNA bias DACs
            obj.LNABiasOutEnable = true(size(obj.deviceNames));
            obj.BiasDACEnable = true(size(obj.deviceNames));
            TempBiasDACMode = cell(size(obj.deviceNames));
            TempBiasDACMode(:) = {'Toggle'};
            obj.BiasDACMode = TempBiasDACMode;
            
            % Configure the external switch control
            obj.ExternalTRPolarity = true(size(obj.deviceNames));
            obj.TRSwitchEnable = true(size(obj.deviceNames));

            % Set the default LNA bias
            obj.LNABiasOff = LNAOff*ones(size(obj.deviceNames));
            obj.LNABiasOn = LNAOn*ones(size(obj.deviceNames));
            
            % Default channel enable
            obj.RxPowerDown = zeros(size(obj.ArrayMapInternal));
            obj.TxPowerDown = zeros(size(obj.ArrayMapInternal));

            % Default PA bias
            obj.PABiasOff = PAOff*ones(size(obj.ArrayMapInternal));
            obj.PABiasOn = PAOn*ones(size(obj.ArrayMapInternal));

            % Default attenuator, gain, and phase
            obj.RxAttn = false(size(obj.ArrayMapInternal));
            obj.RxGain = hex2dec('0x7F')*ones(size(obj.ArrayMapInternal));
            obj.RxPhase = zeros(size(obj.ArrayMapInternal));
            obj.TxAttn = false(size(obj.ArrayMapInternal));
            obj.TxGain = hex2dec('0x7F')*ones(size(obj.ArrayMapInternal));
            obj.TxPhase = zeros(size(obj.ArrayMapInternal));
            
            % Latch in the new settings
            obj.LatchRxSettings();
            obj.LatchTxSettings();
        end
    end
    
    methods
        function LatchRxSettings(obj)
            setAllChipsDeviceAttributeRAW(obj, 'rx_load_spi', num2str(true(size(obj.deviceNames))), true);
        end
        
        function LatchTxSettings(obj)
            setAllChipsDeviceAttributeRAW(obj, 'tx_load_spi', num2str(true(size(obj.deviceNames))), true);
        end
    end
    
    % Get/Set Methods for Channel Attributes
    methods
%         function result = get.DetectorEnable(obj)
%             result = true(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = getAllChipsChannelAttribute(obj, 'detector_en', true, 'logical');
%             end
%         end
%         
%         function set.DetectorEnable(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'detector_en', true, 'logical');
%         end
        
%         function result = get.DetectorPower(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 obj.DetectorEnable = true(size(obj.ArrayMapInternal));
%                 result = getAllChipsChannelAttribute(obj, 'raw', true, 'raw');
%                 obj.DetectorEnable = false(size(obj.ArrayMapInternal));
%             end
%         end
        
        function result = get.PABiasOff(obj)
            result = 255*ones(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                dac_code = getAllChipsChannelAttribute(obj, 'pa_bias_off', true, 'int32');
                result = dac_code*obj.BIAS_CODE_TO_VOLTAGE_SCALE;
            end
        end
        
        function set.PABiasOff(obj, values)
            dac_codes = int64(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsChannelAttribute(obj, dac_codes, 'pa_bias_off', true, 'int64');
        end
        
        function result = get.PABiasOn(obj)
            result = 255*ones(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                dac_code = getAllChipsChannelAttribute(obj, 'pa_bias_on', true, 'int32');
                result = dac_code*obj.BIAS_CODE_TO_VOLTAGE_SCALE;
            end
        end
        
        function set.PABiasOn(obj, values)
            dac_codes = int64(values / obj.BIAS_CODE_TO_VOLTAGE_SCALE);
            setAllChipsChannelAttribute(obj, dac_codes, 'pa_bias_on', true, 'int32');
        end
        
        function result = get.RxAttn(obj)
            result = true(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'attenuation', false, 'logical');
            end
        end
        
        function set.RxAttn(obj, values)
            setAllChipsChannelAttribute(obj, values, 'attenuation', false, 'logical');
        end
        
        function result = get.RxBeamState(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'beam_pos_load', false, 'int32');
            end
        end
        
        function set.RxBeamState(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'RxBeamState');
            setAllChipsChannelAttribute(obj, values, 'beam_pos_load', false, 'int32');
        end
        
        function result = get.RxPowerDown(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = ~getAllChipsChannelAttribute(obj, 'powerdown', false, 'logical');
            end
        end
        
        function set.RxPowerDown(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'powerdown', false, 'logical');
        end
        
%         function result = get.RxGain(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = -1000*getAllChipsChannelAttribute(obj, 'hardwaregain', false, 'double');
%             end
%         end
%         
%         function set.RxGain(obj, values)
%             validateattributes( values, { 'double', 'single', 'uint32'}, ...
%                 { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
%                 '', 'RxGain');
%             setAllChipsChannelAttribute(obj, values, 'hardwaregain', false, 'double');
%         end
        
        function result = get.RxPhase(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'phase', false, 'double');
            end
        end
        
        function set.RxPhase(obj, values)
            %{
            validateattributes( values, { 'double'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','>=',0,'<=',357}, ...
                '', 'RxPhase');
            %}
            setAllChipsChannelAttribute(obj, values, 'phase', false, 'double', 4);
        end
        
        function result = get.TxAttn(obj)
            result = true(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'attenuation', true, 'logical');
            end
        end
        
        function set.TxAttn(obj, values)
            setAllChipsChannelAttribute(obj, values, 'attenuation', true, 'logical');
        end
        
        function result = get.TxBeamState(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'beam_pos_load', true, 'int32');
            end
        end
        
        function set.TxBeamState(obj, values)
            validateattributes( values, { 'double', 'single', 'uint32'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'TxBeamState');
            setAllChipsChannelAttribute(obj, values, 'beam_pos_load', true, 'int32');
        end
        
        function result = get.TxPowerDown(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = ~getAllChipsChannelAttribute(obj, 'powerdown', true, 'logical');
            end
        end
        
        function set.TxPowerDown(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'powerdown', true, 'logical');
        end
        
%         function result = get.TxGain(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = -1000*getAllChipsChannelAttribute(obj, 'hardwaregain', true, 'double');
%             end
%         end
%         
%         function set.TxGain(obj, values)
%             validateattributes( values, { 'double', 'single', 'uint32'}, ...
%                 { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
%                 '', 'TxGain');
%             setAllChipsChannelAttribute(obj, values, 'hardwaregain', true, 'double');
%         end
        
        function result = get.TxPhase(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'phase', true, 'double');
            end
        end
        
        function set.TxPhase(obj, values)
            %{
            validateattributes( values, { 'double'}, ...
                { 'real', 'nonnegative', 'finite', 'nonnan', 'nonempty','>=',0,'<=',357}, ...
                '', 'TxPhase');
            %}
            setAllChipsChannelAttribute(obj, values, 'phase', true, 'double', 4);
        end
        
%         function result = get.RxBiasState(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = getAllChipsChannelAttribute(obj, 'bias_set_load', false, 'logical');
%             end
%         end
%         
%         function set.RxBiasState(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'bias_set_load', false, 'logical');
%         end
        
        function result = get.RxSequencerStart(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'sequence_start', false, 'logical');
            end
        end
        
        function set.RxSequencerStart(obj, values)
            setAllChipsChannelAttribute(obj, values, 'sequence_start', false, 'logical');
        end
        
        function result = get.RxSequencerStop(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = getAllChipsChannelAttribute(obj, 'sequence_end', false, 'logical');
            end
        end
        
        function set.RxSequencerStop(obj, values)
            setAllChipsChannelAttribute(obj, values, 'sequence_end', false, 'logical');
        end
        
%         function result = get.TxBiasState(obj)
%             result = zeros(size(obj.ArrayMapInternal));
%             if ~isempty(obj.iioDevices)
%                 result = ~getAllChipsChannelAttribute(obj, 'bias_set_load', true, 'logical');
%             end
%         end
%         
%         function set.TxBiasState(obj, values)
%             setAllChipsChannelAttribute(obj, values, 'bias_set_load', true, 'logical');
%         end
        
        function result = get.TxSequencerStart(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = ~getAllChipsChannelAttribute(obj, 'sequence_start', true, 'logical');
            end
        end
        
        function set.TxSequencerStart(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'sequence_start', true, 'logical');
        end
        
        function result = get.TxSequencerStop(obj)
            result = zeros(size(obj.ArrayMapInternal));
            if ~isempty(obj.iioDevices)
                result = ~getAllChipsChannelAttribute(obj, 'sequence_end', true, 'logical');
            end
        end
        
        function set.TxSequencerStop(obj, values)
            setAllChipsChannelAttribute(obj, ~values, 'sequence_end', true, 'logical');
        end
        
        function result = get.Temp(obj)
            result = zeros(numel(obj.deviceNames), 1);
            for d = 1:numel(obj.iioDevices)
                result(d) = str2double(obj.getAttributeRAW('temp0', 'raw', false, obj.iioDevices{d}));
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
                'beam_pos_save', sprintf('%d, %d, %d, %f', State, Attn, Gain, Phase), false, obj.deviceNames{ChipIDIndx});
        end
        
        function SaveTxBeam(obj, ChipIDIndx, ChIndx, State, Attn, Gain, Phase)
             validateattributes( State, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',120}, ...
                '', 'State');
             validateattributes( Gain, { 'double','single', 'uint32' }, ...
                { 'real', 'nonnegative','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',0,'<=',127}, ...
                '', 'Gain');             
            obj.setAttributeRAW(sprintf('voltage%d', ChIndx), ...
                'beam_pos_save', sprintf('%d, %d, %d, %f', State, Attn, Gain, Phase), true, obj.deviceNames{ChipIDIndx});
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
end