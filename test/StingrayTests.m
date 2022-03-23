classdef StingrayTests < HardwareTests
    properties
        uri = 'ip:10.72.162.61';
        author = 'ADI';
        sray
    end
    
    methods(TestMethodSetup)
        function SetupStingray(testCase)
            % Setup Stingray
            testCase.sray = adi.Stingray;
            testCase.sray.uri = testCase.uri;
            testCase.sray();
        end
    end
    
    methods(TestMethodTeardown)
        function ResetStingray(testCase)
            clear testCase.sray;
        end
    end
    
    % Device Attribute Tests
    methods (Test)
        function testMode(testCase)
            values = cell(1, size(testCase.sray.ArrayMap, 1));
            values(:) = {'Rx'};            
            values(randi([1 size(testCase.sray.ArrayMap, 1)], 1, 3)) = {'Tx'};
            values(randi([1 size(testCase.sray.ArrayMap, 1)], 1, 3)) = {'Disabled'};
            testCase.sray.Mode = values;
            rvalues = testCase.sray.Mode;
            testCase.verifyEqual(rvalues,values);
            values(:) = {'Disabled'};
            testCase.sray.Mode = values;
        end
        
        function testStateTxOrRx(testCase)
            values = cell(1, size(testCase.sray.ArrayMap, 1));
            values(:) = {'Rx'};            
            values(randi([1 size(testCase.sray.ArrayMap, 1)], 1, 3)) = {'Tx'};
            testCase.sray.StateTxOrRx = values;
            rvalues = testCase.sray.StateTxOrRx;
            testCase.verifyEqual(rvalues,values);
            values(:) = {'Rx'};
            testCase.sray.StateTxOrRx = values;
        end
        
        function testRxEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.RxEnable = values;
            rvalues = testCase.sray.RxEnable;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxEnable = logical(false(1, size(testCase.sray.ArrayMap, 1)));
        end
        
        function testTxEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.TxEnable = values;
            rvalues = testCase.sray.TxEnable;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxEnable = logical(false(1, size(testCase.sray.ArrayMap, 1)));
        end
        
        function testLNABiasOutEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.LNABiasOutEnable = values;
            rvalues = testCase.sray.LNABiasOutEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testLNABiasOn(testCase)
            values = randi([60 100], 1, size(testCase.sray.ArrayMap, 1))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.LNABiasOn = values;
            rvalues = testCase.sray.LNABiasOn;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.LNABiasOn = 100*ones(1, size(testCase.sray.ArrayMap, 1))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testBeamMemEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.BeamMemEnable = values;
            rvalues = testCase.sray.BeamMemEnable;
            testCase.verifyEqual(rvalues,values);
        end
        %{
        function testBiasDACEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.BiasDACEnable = values;
            rvalues = testCase.sray.BiasDACEnable;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testBiasDACMode(testCase)
            values = cell(1, size(testCase.sray.ArrayMap, 1));
            values(:) = {'Toggle'};            
            values(randi([1 size(testCase.sray.ArrayMap, 1)], 1, 3)) = {'On'};
            testCase.sray.BiasDACMode = values;
            rvalues = testCase.sray.BiasDACMode;
            testCase.verifyEqual(rvalues,values);
        end
        %{
        function testBiasMemEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.BiasMemEnable = values;
            rvalues = testCase.sray.BiasMemEnable;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testCommonMemEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.CommonMemEnable = values;
            rvalues = testCase.sray.CommonMemEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testCommonRxBeamState(testCase)
            values = randi([0 120])*ones(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.CommonRxBeamState = values;
            rvalues = testCase.sray.CommonRxBeamState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testCommonTxBeamState(testCase)
            values = randi([0 120])*ones(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.CommonTxBeamState = values;
            rvalues = testCase.sray.CommonTxBeamState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testExternalTRPin(testCase)
            values = cell(1, size(testCase.sray.ArrayMap, 1));
            values(:) = {'Pos'};            
            testCase.sray.ExternalTRPin = values;
            rvalues = testCase.sray.ExternalTRPin;
            testCase.verifyEqual(rvalues,values);
            
            values = cell(1, size(testCase.sray.ArrayMap, 1));
            values(:) = {'Neg'};            
            testCase.sray.ExternalTRPin = values;
            rvalues = testCase.sray.ExternalTRPin;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testExternalTRPolarity(testCase)
            values = true(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.ExternalTRPolarity = values;
            rvalues = testCase.sray.ExternalTRPolarity;
            testCase.verifyEqual(rvalues,values);
            
            values = false(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.ExternalTRPolarity = values;
            rvalues = testCase.sray.ExternalTRPolarity;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testLNABiasOff(testCase)
            values = randi([60 100], 1, size(testCase.sray.ArrayMap, 1))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.LNABiasOff = values;
            rvalues = testCase.sray.LNABiasOff;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.LNABiasOn = 100*ones(size(testCase.sray.ArrayMap, 1))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testPolState(testCase)
            values = true(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.PolState = values;
            rvalues = testCase.sray.PolState;
            testCase.verifyEqual(rvalues,values);
            
            values = false(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.PolState = values;
            rvalues = testCase.sray.PolState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testPolSwitchEnable(testCase)
            values = true(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.PolSwitchEnable = values;
            rvalues = testCase.sray.PolSwitchEnable;
            testCase.verifyEqual(rvalues,values);
            
            values = false(1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.PolSwitchEnable = values;
            rvalues = testCase.sray.PolSwitchEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxLNABiasCurrent(testCase)
            values = randi([5 8], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.RxLNABiasCurrent = values;
            rvalues = testCase.sray.RxLNABiasCurrent;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxLNABiasCurrent = 5*ones(size(testCase.sray.ArrayMap, 1));
        end
        
        function testRxLNAEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.RxLNAEnable = values;
            rvalues = testCase.sray.RxLNAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxToTxDelay1(testCase)
            values = randi([0 15], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.RxToTxDelay1 = values;
            rvalues = testCase.sray.RxToTxDelay1;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxToTxDelay2(testCase)
            values = randi([0 15], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.RxToTxDelay2 = values;
            rvalues = testCase.sray.RxToTxDelay2;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxVGAEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.RxVGAEnable = values;
            rvalues = testCase.sray.RxVGAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxVGABiasCurrentVM(testCase)
            values = randi([2 5], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.RxVGABiasCurrentVM = values;
            rvalues = testCase.sray.RxVGABiasCurrentVM;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxVGABiasCurrentVM = 2*ones(size(testCase.sray.ArrayMap, 1));
        end
        
        function testRxVMEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.RxVMEnable = values;
            rvalues = testCase.sray.RxVMEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testSequencerEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.SequencerEnable = values;
            rvalues = testCase.sray.SequencerEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTRSwitchEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.TRSwitchEnable = values;
            rvalues = testCase.sray.TRSwitchEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxPABiasCurrent(testCase)
            values = randi([3 6], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.TxPABiasCurrent = values;
            rvalues = testCase.sray.TxPABiasCurrent;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxPABiasCurrent = 3*ones(size(testCase.sray.ArrayMap, 1));
        end
        
        function testTxPAEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.TxPAEnable = values;
            rvalues = testCase.sray.TxPAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxToRxDelay1(testCase)
            values = randi([0 15], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.TxToRxDelay1 = values;
            rvalues = testCase.sray.TxToRxDelay1;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxToRxDelay2(testCase)
            values = randi([0 15], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.TxToRxDelay2 = values;
            rvalues = testCase.sray.TxToRxDelay2;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxVGAEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.TxVGAEnable = values;
            rvalues = testCase.sray.TxVGAEnable;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxVGABiasCurrentVM(testCase)
            values = randi([2 5], 1, size(testCase.sray.ArrayMap, 1));
            testCase.sray.TxVGABiasCurrentVM = values;
            rvalues = testCase.sray.TxVGABiasCurrentVM;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxVGABiasCurrentVM = 2*ones(size(testCase.sray.ArrayMap, 1));
        end
        
        function testTxVMEnable(testCase)
            values = logical(randi([0 1], 1, size(testCase.sray.ArrayMap, 1)));
            testCase.sray.TxVMEnable = values;
            rvalues = testCase.sray.TxVMEnable;
            testCase.verifyEqual(rvalues,values);
        end
    end
    
    % Channel Attribute Tests
    methods (Test)
        %{
        function testDetectorEnable(testCase)
            values = logical(randi([0 1], size(testCase.sray.ArrayMap)));
            testCase.sray.DetectorEnable = values;
            rvalues = testCase.sray.DetectorEnable;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testPABiasOff(testCase)
            values = randi([60 100], size(testCase.sray.ArrayMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.PABiasOff = values;
            rvalues = testCase.sray.PABiasOff;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.PABiasOff = 100*ones(size(testCase.sray.ArrayMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testPABiasOn(testCase)
            values = randi([60 100], size(testCase.sray.ArrayMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
            testCase.sray.PABiasOn = values;
            rvalues = testCase.sray.PABiasOn;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.PABiasOn = 100*ones(size(testCase.sray.ArrayMap))*...
                testCase.sray.BIAS_CODE_TO_VOLTAGE_SCALE;
        end
        
        function testRxAttn(testCase)
            values = logical(randi([0 1], size(testCase.sray.ArrayMap)));
            testCase.sray.RxAttn = values;
            rvalues = testCase.sray.RxAttn;
            testCase.verifyEqual(rvalues,values);
        end        
        
        function testRxBeamState(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(randi([0 120], 1, tmp_size(1)), tmp_size(2), 1).';
            testCase.sray.RxBeamState = values;
            rvalues = testCase.sray.RxBeamState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testRxPowerDown(testCase)
            values = logical(randi([0 1], size(testCase.sray.ArrayMap)));
            testCase.sray.RxPowerDown = values;
            rvalues = testCase.sray.RxPowerDown;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxPowerDown = false(size(testCase.sray.ArrayMap));
        end
        %{
        function testRxGain(testCase)
            values = randi([0 127], size(testCase.sray.ArrayMap));
            testCase.sray.RxGain = values;
            rvalues = testCase.sray.RxGain;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testRxPhase(testCase)
            values = randi([0 127], size(testCase.sray.ArrayMap));
            testCase.sray.RxPhase = values;
            rvalues = testCase.sray.RxPhase;
            testCase.verifyEqual(rvalues,values, "AbsTol", 4);
        end
        
        function testTxAttn(testCase)
            values = logical(randi([0 1], size(testCase.sray.ArrayMap)));
            testCase.sray.TxAttn = values;
            rvalues = testCase.sray.TxAttn;
            testCase.verifyEqual(rvalues,values);
        end        
        
        function testTxBeamState(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(randi([0 120], 1, tmp_size(1)), tmp_size(2), 1).';
            testCase.sray.TxBeamState = values;
            rvalues = testCase.sray.TxBeamState;
            testCase.verifyEqual(rvalues,values);
        end
        
        function testTxPowerDown(testCase)
            values = logical(randi([0 1], size(testCase.sray.ArrayMap)));
            testCase.sray.TxPowerDown = values;
            rvalues = testCase.sray.TxPowerDown;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxPowerDown = false(size(testCase.sray.ArrayMap));
        end
        %{
        function testTxGain(testCase)
            values = randi([0 127], size(testCase.sray.ArrayMap));
            testCase.sray.TxGain = values;
            rvalues = testCase.sray.TxGain;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testTxPhase(testCase)
            values = randi([0 127], size(testCase.sray.ArrayMap));
            testCase.sray.TxPhase = values;
            rvalues = testCase.sray.TxPhase;
            testCase.verifyEqual(rvalues,values, "AbsTol", 4);
        end
        %{
        function testRxBiasState(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(2))), tmp_size(1), 1);
            testCase.sray.RxBiasState = values;
            rvalues = testCase.sray.RxBiasState;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testRxSequencerStart(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.RxSequencerStart = values;
            rvalues = testCase.sray.RxSequencerStart;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxSequencerStart = false(size(testCase.sray.ArrayMap));
        end
        
        function testRxSequencerStop(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.RxSequencerStop = values;
            rvalues = testCase.sray.RxSequencerStop;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.RxSequencerStop = false(size(testCase.sray.ArrayMap));
        end
        %{
        function testTxBiasState(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(2))), tmp_size(1), 1);
            testCase.sray.TxBiasState = values;
            rvalues = testCase.sray.TxBiasState;
            testCase.verifyEqual(rvalues,values);
        end
        %}
        function testTxSequencerStart(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.TxSequencerStart = values;
            rvalues = testCase.sray.TxSequencerStart;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxSequencerStart = false(size(testCase.sray.ArrayMap));
        end
        
        function testTxSequencerStop(testCase)
            tmp_size = size(testCase.sray.ArrayMap);
            values = repmat(logical(randi([0 1], 1, tmp_size(1))), tmp_size(2), 1).';
            testCase.sray.TxSequencerStop = values;
            rvalues = testCase.sray.TxSequencerStop;
            testCase.verifyEqual(rvalues,values);
            testCase.sray.TxSequencerStop = false(size(testCase.sray.ArrayMap));
        end
    end
end