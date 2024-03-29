classdef PlutoTDD < adi.internal.AXICorePlutoTDD
    % adi.PlutoTDD Analog Devices Inc. ADALM-PHASER development platform
    % TDD Engine Controller
    %   The adi.PlutoTDD system object is an API to control the
    %   ADALM-PHASER X/Ku Band Beamforming Developer Platform TDD Engine
    %
    %   rx = adi.PlutoTDD;
    %   rx = adi.PlutoTDD('uri','ip:192.168.2.1');
    %
    %   <a href="https://wiki.analog.com/resources/eval/developer-kits/x-band-dev-kit">Stingray X/Ku Band Beamforming Developer Platform Wiki</a>

    properties(Nontunable, Hidden)
        kernelBuffersCount = 0;
        dataTypeStr = 'int16';
        iioDriverName = 'TDDPluto';
        devName = 'TDDPluto';
        SamplesPerFrame = 0;
        SkipInit = false;
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

    methods
        %% Constructor
        function obj = PlutoTDD(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.internal.AXICorePlutoTDD(varargin{:});
        end
        % Destructor
        function delete(obj)
        end

    end

    methods (Hidden, Access = protected)
        function setupImpl(obj)
            setupLib(obj);
            initPointers(obj);
            getContext(obj);
            setContextTimeout(obj);
            obj.needsTeardown = true;
            obj.ConnectedToDevice = true;
            setupInit(obj);
        end

        function setupInit(obj)
            % AXI-Core-TDD
            setupInit@adi.internal.AXICorePlutoTDD(obj);
        end

        function v = stepImpl(~)
            v = true;
        end

        function flag = isInactivePropertyImpl(obj, prop)
            % Return false if property is visible based on object
            flag = false;
            if strcmpi('EnabledChannels',prop)
                flag = true;
            end
            % Call the base class method
            flag = flag || isInactivePropertyImpl@adi.common.RxTx(obj, prop);

        end
    end

    methods (Access=protected)
        function numOut = getNumOutputsImpl(~)
            numOut = 1;
        end
    end
end
