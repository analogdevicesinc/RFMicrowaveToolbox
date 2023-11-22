classdef ADAR1000Array < adi.internal.ADAR100x
    %ADAR1000Array Beamformer
    properties(Nontunable, Hidden)
        ElementToChipChannelMap = [3,4,1,2, 3,4,1,2]; % channel attributes
        ElementToChipMap = [2,2,2,2, 1,1,1,1]; % channel attributes
        SubarrayToChipMap = [2, 1]; % device attributes
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
    end
end