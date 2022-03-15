classdef Stingray < adi.internal.ADAR100x & ...
        adi.internal.StingrayControl & ...
        adi.internal.XUD1aControl & ...
        adi.internal.ADF4371 & ...
        adi.internal.AXICoreTDD
    properties(Nontunable, Hidden)
        ArrayMapInternal = [2 6 5 1; 4 8 7 3; 10 14 13 9; 12 16 15 11; ...
            18 22 21 17; 20 24 23 19; 26 30 29 25; 28 32 31 27];
    end
    
    properties(Dependent)
        ArrayMap
    end
    
    properties(Hidden)
        deviceNames = {...
            'adar1000_csb_1_1',...
            'adar1000_csb_1_2',...
            'adar1000_csb_1_3',...
            'adar1000_csb_1_4',...
            'adar1000_csb_2_1',...
            'adar1000_csb_2_2',...
            'adar1000_csb_2_3',...
            'adar1000_csb_2_4'};
    end
    
    properties
        NumADAR1000s = 2
    end
    
    methods
        %% Constructor
        function obj = Stingray(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.internal.ADAR100x(varargin{:});
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
            % Stingray Control
            setupInit@adi.internal.StingrayControl(obj);
            % XUD1a Control
            setupInit@adi.internal.XUD1aControl(obj);
            % PLL
            setupInit@adi.internal.ADF4371(obj);
            % AXI-Core-TDD
            setupInit@adi.internal.AXICoreTDD(obj);
        end
    end
end