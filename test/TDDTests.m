classdef TDDTests < HardwareTests

    properties(TestParameter)
        numericProp = {'BurstCount','CounterInt','Enable',...
        'FrameLength','Secondary','SyncTerminalType'};
    end

    properties
        uri = 'ip:192.168.86.21';
        author = 'ADI';
    end
    
    methods(TestMethodSetup)
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        function testNumericProps(testCase,numericProp)
            tdd = adi.PhaserTDD;
            tdd.uri = testCase.uri;
            tdd();
            default = tdd.(numericProp);
            tdd.(numericProp) = 1;
            testCase.verifyEqual(tdd.(numericProp),1);
            tdd.(numericProp) = default;
            testCase.verifyEqual(tdd.(numericProp),default);
        end
        
    end
end