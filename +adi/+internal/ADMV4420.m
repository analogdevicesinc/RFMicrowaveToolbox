classdef (Abstract) ADMV4420 < adi.common.Attribute & ...
        adi.common.Channel & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    properties
        %% LO Frequency in Hz
        LoFreqHz = 17500000000
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
        PfdFreqHz = 50000000
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
    
    properties(Nontunable, Hidden)
        Timeout = Inf;
        kernelBuffersCount = 0;
        dataTypeStr = 'int16';
        phyDevName = 'admv4420';
        % Name of driver instance in device tree
        iioDriverName = 'dev';
        iioDevPHY
        devName = 'admv4420';
        SamplesPerFrame = 0;
    end
    
    properties(Hidden)
        iioDevices = {};
    end
    
    properties (Hidden, Constant, Logical)
        ComplexData = false;
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
    
    methods (Hidden, Access = protected)        
        function setupImpl(obj)
            % Setup LibIIO
            setupLib(obj);
            % Initialize the pointers
            initPointers(obj);
            getContext(obj);
            setContextTimeout(obj);
            % Flags
            obj.needsTeardown = true;
            obj.ConnectedToDevice = true;
            % Call final stage
            setupInit(obj);
        end
    end
end