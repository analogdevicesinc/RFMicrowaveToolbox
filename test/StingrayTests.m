classdef StingrayTests < HardwareTests
    properties        
        uri = 'ip:192.168.1.101';
        author = 'ADI';
        sray
    end
    
    methods(TestMethodSetup)
        function SetupStingray(testCase)
            % Setup Stingray
            testCase.sray = adi.Stingray;
            testCase.sray.uri = testCase.uri;
            testCase.sray.EnableReadCheckOnWrite = false;
            testCase.sray();
        end        
    end
    
    methods(TestMethodTeardown)
        function ResetStingray(testCase)
            clear testCase.sray;
        end
    end
    
    % ADAR1000 Device Attribute Tests
    methods (Test)
        function testMode(testCase)
            values = cell(size(testCase.sray.SubarrayToChipMap));
            values(:) = {'Rx'};            
            values(randi([1 numel(testCase.sray.SubarrayToChipMap)], 1, 3)) = {'Tx'};
            values(randi([1 numel(testCase.sray.SubarrayToChipMap)], 1, 3)) = {'Disabled'};
            testCase.sray.Mode = values;
            rvalues = testCase.sray.Mode;
            testCase.verifyEqual(rvalues,values);
            values(:) = {'Disabled'};
            testCase.sray.Mode = values;
        end
        
        function testLNABiasOutEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.LNABiasOutEnable = values;
            rvalues = testCase.sray.LNABiasOutEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testLNABiasOn(testCase)
            values = randi([60 100], size(testCase.sray.SubarrayToChipMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.LNABiasOn = values;
            rvalues = testCase.sray.LNABiasOn;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.LNABiasOn = 100*ones(size(testCase.sray.SubarrayToChipMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testBeamMemEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.BeamMemEnable = values;
            rvalues = testCase.sray.BeamMemEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testBiasDACEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.BiasDACEnable = values;
            rvalues = testCase.sray.BiasDACEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testBiasDACMode(testCase)
            values = cell(size(testCase.sray.SubarrayToChipMap));
            values(:) = {'Toggle'};            
            values(randi([1 numel(testCase.sray.SubarrayToChipMap)], 1, 3)) = {'On'};
            testCase.sray.BiasDACMode = values;
            rvalues = testCase.sray.BiasDACMode;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testBiasMemEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.BiasMemEnable = values;
            pause(2);
            rvalues = testCase.sray.BiasMemEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testCommonMemEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.CommonMemEnable = values;
            rvalues = testCase.sray.CommonMemEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testCommonRxBeamState(testCase)
            values = randi([0 120])*ones(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.CommonRxBeamState = values;
            rvalues = testCase.sray.CommonRxBeamState;
            testCase.verifyEqual(rvalues,int32(values));
        end
        
        function testCommonTxBeamState(testCase)
            values = randi([0 120])*ones(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.CommonTxBeamState = values;
            rvalues = testCase.sray.CommonTxBeamState;
            testCase.verifyEqual(rvalues,int32(values));
        end
        
        function testExternalTRPin(testCase)
            values = cell(size(testCase.sray.SubarrayToChipMap));
            values(:) = {'Pos'};            
            testCase.sray.ExternalTRPin = values;
            rvalues = testCase.sray.ExternalTRPin;
            testCase.verifyEqual(rvalues,values);
            
            values = cell(size(testCase.sray.SubarrayToChipMap));
            values(:) = {'Neg'};            
            testCase.sray.ExternalTRPin = values;
            rvalues = testCase.sray.ExternalTRPin;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testExternalTRPolarity(testCase)
            values = true(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.ExternalTRPolarity = values;
            rvalues = testCase.sray.ExternalTRPolarity;
            testCase.verifyEqual(rvalues,values);
            
            values = false(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.ExternalTRPolarity = values;
            rvalues = testCase.sray.ExternalTRPolarity;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testLNABiasOff(testCase)
            values = randi([60 100], size(testCase.sray.SubarrayToChipMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.LNABiasOff = values;
            rvalues = testCase.sray.LNABiasOff;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.LNABiasOn = 100*ones(size(testCase.sray.SubarrayToChipMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testPolState(testCase)
            values = true(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.PolState = values;
            rvalues = testCase.sray.PolState;
            testCase.verifyEqual(rvalues,values);
            
            values = false(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.PolState = values;
            rvalues = testCase.sray.PolState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testPolSwitchEnable(testCase)
            values = true(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.PolSwitchEnable = values;
            rvalues = testCase.sray.PolSwitchEnable;
            testCase.verifyEqual(rvalues,values);
            
            values = false(size(testCase.sray.SubarrayToChipMap));
            testCase.sray.PolSwitchEnable = values;
            rvalues = testCase.sray.PolSwitchEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxLNABiasCurrent(testCase)
            values = randi([5 8], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.RxLNABiasCurrent = values;
            rvalues = testCase.sray.RxLNABiasCurrent;
            testCase.verifyEqual(rvalues,int32(values));
            testCase.sray.RxLNABiasCurrent = 5*ones(size(testCase.sray.SubarrayToChipMap));
        end
        
        function testRxLNAEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.RxLNAEnable = values;
            rvalues = testCase.sray.RxLNAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxToTxDelay1(testCase)
            values = randi([0 15], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.RxToTxDelay1 = values;
            rvalues = testCase.sray.RxToTxDelay1;
            testCase.verifyEqual(rvalues,int32(values));
        end
        
        function testRxToTxDelay2(testCase)
            values = randi([0 15], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.RxToTxDelay2 = values;
            rvalues = testCase.sray.RxToTxDelay2;
            testCase.verifyEqual(rvalues,int32(values));
        end
        
        function testRxVGAEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.RxVGAEnable = values;
            rvalues = testCase.sray.RxVGAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxVGABiasCurrentVM(testCase)
            values = randi([2 5], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.RxVGABiasCurrentVM = values;
            rvalues = testCase.sray.RxVGABiasCurrentVM;
            testCase.verifyEqual(rvalues,int32(values));
            testCase.sray.RxVGABiasCurrentVM = 2*ones(size(testCase.sray.SubarrayToChipMap));
        end
        
        function testRxVMEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.RxVMEnable = values;
            rvalues = testCase.sray.RxVMEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testSequencerEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.SequencerEnable = values;
            rvalues = testCase.sray.SequencerEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTRSwitchEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.TRSwitchEnable = values;
            rvalues = testCase.sray.TRSwitchEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxPABiasCurrent(testCase)
            values = randi([3 6], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.TxPABiasCurrent = values;
            rvalues = testCase.sray.TxPABiasCurrent;
            testCase.verifyEqual(rvalues,int32(values));
            testCase.sray.TxPABiasCurrent = 3*ones(size(testCase.sray.SubarrayToChipMap));
        end
        
        function testTxPAEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.TxPAEnable = values;
            rvalues = testCase.sray.TxPAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxToRxDelay1(testCase)
            values = randi([0 15], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.TxToRxDelay1 = values;
            rvalues = testCase.sray.TxToRxDelay1;
            testCase.verifyEqual(rvalues,int32(values));
        end
        
        function testTxToRxDelay2(testCase)
            values = randi([0 15], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.TxToRxDelay2 = values;
            rvalues = testCase.sray.TxToRxDelay2;
            testCase.verifyEqual(rvalues,int32(values));
        end
        
        function testTxVGAEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.TxVGAEnable = values;
            rvalues = testCase.sray.TxVGAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxVGABiasCurrentVM(testCase)
            values = randi([2 5], size(testCase.sray.SubarrayToChipMap));
            testCase.sray.TxVGABiasCurrentVM = values;
            rvalues = testCase.sray.TxVGABiasCurrentVM;
            testCase.verifyEqual(rvalues,int32(values));
            testCase.sray.TxVGABiasCurrentVM = 2*ones(size(testCase.sray.SubarrayToChipMap));
        end
        
        function testTxVMEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.SubarrayToChipMap)));
            testCase.sray.TxVMEnable = values;
            rvalues = testCase.sray.TxVMEnable;
            testCase.verifyEqual(rvalues,values);
        end
    end
    
    % ADAR1000 Channel Attribute Tests
    methods (Test)
        
        function testDetectorEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.ElementToChipChannelMap)));
            testCase.sray.DetectorEnable = values;
            rvalues = testCase.sray.DetectorEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testPABiasOff(testCase)
            values = randi([60 100], size(testCase.sray.ElementToChipChannelMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.PABiasOff = values;
            rvalues = testCase.sray.PABiasOff;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.PABiasOff = 100*ones(size(testCase.sray.ElementToChipChannelMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testPABiasOn(testCase)
            values = randi([60 100], size(testCase.sray.ElementToChipChannelMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.PABiasOn = values;
            rvalues = testCase.sray.PABiasOn;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.PABiasOn = 100*ones(size(testCase.sray.ElementToChipChannelMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testRxAttn(testCase)
            values = logical(randi([0 1], size(testCase.sray.ElementToChipChannelMap)));
            testCase.sray.RxAttn = values;
            rvalues = testCase.sray.RxAttn;
            testCase.verifyEqual(rvalues,values);
        end        
        
        function testRxBeamState(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(randi([0 120], 1, tmp_size(1)), tmp_size(2), 1).';
            testCase.sray.RxBeamState = values;
            rvalues = testCase.sray.RxBeamState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxPowerDown(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.RxPowerDown = values;
            rvalues = testCase.sray.RxPowerDown;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxPowerDown = true(size(testCase.sray.ElementToChipChannelMap));
        end
        
        function testRxGain(testCase)
            values = randi([0 127], size(testCase.sray.ElementToChipChannelMap));
            testCase.sray.RxGain = values;
            rvalues = testCase.sray.RxGain;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxPhase(testCase)
            values = randi([0 127], size(testCase.sray.ElementToChipChannelMap));
            testCase.sray.RxPhase = values;
            rvalues = testCase.sray.RxPhase;
            testCase.verifyEqual(rvalues,values, "AbsTol", 4);
        end
        
        function testTxAttn(testCase)
            values = logical(randi([0 1], size(testCase.sray.ElementToChipChannelMap)));
            testCase.sray.TxAttn = values;
            rvalues = testCase.sray.TxAttn;
            testCase.verifyEqual(rvalues,values);
        end        
        
        function testTxBeamState(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(randi([0 120], 1, tmp_size(1)), tmp_size(2), 1).';
            testCase.sray.TxBeamState = values;
            rvalues = testCase.sray.TxBeamState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxPowerDown(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.TxPowerDown = values;
            rvalues = testCase.sray.TxPowerDown;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxPowerDown = true(size(testCase.sray.ElementToChipChannelMap));
        end
        
        function testTxGain(testCase)
            values = randi([0 127], size(testCase.sray.ElementToChipChannelMap));
            testCase.sray.TxGain = values;
            rvalues = testCase.sray.TxGain;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxPhase(testCase)
            values = randi([0 127], size(testCase.sray.ElementToChipChannelMap));
            testCase.sray.TxPhase = values;
            rvalues = testCase.sray.TxPhase;
            testCase.verifyEqual(rvalues,values, "AbsTol", 4);
        end
        %{
        function testRxBiasState(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(2))), tmp_size(1), 1);
            testCase.sray.RxBiasState = values;
            rvalues = testCase.sray.RxBiasState;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testRxSequencerStart(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.RxSequencerStart = values;
            rvalues = testCase.sray.RxSequencerStart;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxSequencerStart = false(size(testCase.sray.ElementToChipChannelMap));
        end
        
        function testRxSequencerStop(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.RxSequencerStop = values;
            rvalues = testCase.sray.RxSequencerStop;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxSequencerStop = false(size(testCase.sray.ElementToChipChannelMap));
        end
        %{
        function testTxBiasState(testCase)
            tmp_size = size(testCase.sray.SubarrayToChipMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(2))), tmp_size(1), 1);
            testCase.sray.TxBiasState = values;
            rvalues = testCase.sray.TxBiasState;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testTxSequencerStart(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.TxSequencerStart = values;
            rvalues = testCase.sray.TxSequencerStart;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxSequencerStart = false(size(testCase.sray.ElementToChipChannelMap));
        end
        
        function testTxSequencerStop(testCase)
            tmp_size = size(testCase.sray.ElementToChipChannelMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.TxSequencerStop = values;
            rvalues = testCase.sray.TxSequencerStop;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxSequencerStop = false(size(testCase.sray.ElementToChipChannelMap));
        end
    end

    % XUD1a tests
    methods (Test)
        function testSelectChannelSetMode(testCase)
            SelectChannelSetMode = [...
                "A_Tx", "A_RxLG", "A_RxHG", ...
                "B_Tx", "B_RxLG", "B_RxHG", ...
                "C_Tx", "C_RxLG", "C_RxHG", ...
                "D_Tx", "D_RxLG", "D_RxHG"];
            index = randi(numel(SelectChannelSetMode));
            testCase.sray.SelectChannelSetMode = SelectChannelSetMode(index);

            % check Tx/Rx selected
            % check Rx set to Low Gain/High Gain
            switch index
                case {1, 2, 3}
                    TxRxValue = testCase.sray.TXRX0;
                case {4, 5, 6}
                    TxRxValue = testCase.sray.TXRX1;
                case {7, 8, 9}
                    TxRxValue = testCase.sray.TXRX2;
                case {10, 11, 12}
                    TxRxValue = testCase.sray.TXRX3;
            end
            RxGainModeValue = testCase.sray.RxGainMode;

            if any([1, 4, 7, 10] == index)
                testCase.verifyEqual(TxRxValue, 0);
                testCase.verifyEqual(RxGainModeValue, 0);
            else
                testCase.verifyEqual(TxRxValue, 1);
                if contains(SelectChannelSetMode(index), 'LG')
                    testCase.verifyEqual(RxGainModeValue, 0);
                else
                    testCase.verifyEqual(RxGainModeValue, 1);
                end
            end
        end

        function testPllOutputSel(testCase)
            value = randi(2)-1;
            testCase.sray.PllOutputSel = value;
            rvalue = testCase.sray.PllOutputSel;
            testCase.verifyEqual(rvalue,value);
            testCase.sray.PllOutputSel = 1;
        end
    end

    % ADF4371 tests
    methods (Test)
        function testADF4371Name(testCase)
            ADF4371Name = ["RF16x", "RF32x"];
            index = randi(numel(ADF4371Name));
            value = ADF4371Name(index);
            testCase.sray.ADF4371Name = value;
            rvalue = testCase.sray.ADF4371Name;
            testCase.verifyEqual(rvalue,value);
            testCase.sray.ADF4371Name = "RF16x";
        end

        function testADF4371Frequency(testCase)
            freq_a = 8000;
            freq_b = 16000;
            freq = (freq_b-freq_a).*rand(1,1) + freq_a;
            ADF4371Frequency = freq*1e6;
            testCase.sray.ADF4371Frequency = ADF4371Frequency;
            rvalue = testCase.sray.ADF4371Frequency;
            testCase.verifyEqual(rvalue,ADF4371Frequency);
            testCase.sray.ADF4371Frequency = 15000000000;
        end

        function testADF4371Phase(testCase)
            value = randi(359999);
            testCase.sray.ADF4371Phase = value;
            rvalue = testCase.sray.ADF4371Phase;
            testCase.verifyEqual(rvalue,value);
            testCase.sray.ADF4371Phase = 359999;
        end
    end
end