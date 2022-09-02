classdef ADAR1000 < adi.internal.ADAR100x
    properties(Nontunable, Hidden)
        ArrayMapInternal = [1,2,3,4];
    end
    
    properties(Hidden)
       deviceNames = {'adar1000_csb_1_1'};
    end
        
    methods
        %% Constructor
        function obj = ADAR1000(varargin)
            coder.allowpcode('plain');
            obj = obj@adi.internal.ADAR100x(varargin{:});
        end
        % Destructor
        function delete(obj)
        end
    end
end