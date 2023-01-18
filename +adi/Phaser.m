classdef Phaser < adi.internal.ADAR100x & ...
        adi.internal.ADF4159 & ...
        adi.internal.AXICoreTDD
    % adi.Phaser Analog Devices Inc. ADALM-PHASER beamformer development platform
    %   The adi.Phaser system object is an API to control the
    %   ADALM-PHASER X/Ku Band Beamforming Developer Platform.
    %
    %   rx = adi.Phaser;
    %   rx = adi.Phaser('uri','ip:192.168.2.1');
    %
    %   <a href="https://wiki.analog.com/resources/eval/developer-kits/x-band-dev-kit">Stingray X/Ku Band Beamforming Developer Platform Wiki</a>
    properties(Nontunable, Hidden)
        ArrayMapInternal = [7,8,5,6,3,4,1,2];
        ElementToChipChannelMap = [3,4,1,2, 3,4,1,2]; % channel attributes
        ElementToChipMap = [2,2,2,2, 1,1,1,1]; % channel attributes
        SubarrayToChipMap = [2, 1]; % device attributes
    end
    
    properties(Dependent)
        %ArrayMap Map of physical array to ADAR1000 channel array
        ArrayMap
    end
    
    properties(Hidden)
        deviceNames = {...
            'adar1000_0',...
            'adar1000_1'};
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
                
        function set.ArrayMap(obj,value)
            obj.ArrayMapInternal = value;
        end
        function value = get.ArrayMap(obj)
            value = obj.ArrayMapInternal;
        end
    end

    methods (Hidden, Access = protected)
        function setupInit(obj)
            setupInit@adi.internal.ADAR100x(obj);
            % PLL
            setupInit@adi.internal.ADF4159(obj);
            % AXI-Core-TDD
%             setupInit@adi.internal.AXICoreTDD(obj);
        end
    end
end