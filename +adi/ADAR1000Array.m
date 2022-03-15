classdef ADAR1000Array < adi.internal.ADAR100x
    %ADAR1000Array Beamformer
    properties (Nontunable)
    end
    
    properties(Dependent)
        ArrayMap
    end
    
    properties(Nontunable, Hidden)
        ArrayMapInternal = [1,2,3,4;5,6,7,8];
    end
    
    properties(Hidden)
       deviceNames = {'adar1000_csb_1_1','adar1000_csb_1_2'};
    end
        
    methods
        %% Constructor
        function obj = ADAR1000Array(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.internal.ADAR100x(varargin{:});
        end
        % Destructor
        function delete(obj)
        end
        % Sets
        function set.ArrayMap(obj,value)
            obj.ArrayMapInternal = value;
        end
        function value = get.ArrayMap(obj)
            value = obj.ArrayMapInternal;
        end
    end
end