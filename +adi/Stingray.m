classdef Stingray < adi.internal.ADAR100x & ...
        adi.internal.StingrayControl & ...
        adi.internal.XUD1aControl & ...
        adi.internal.ADF4371 & ...
        adi.internal.AXICoreTDD & ...
        adi.internal.LTC2314
    % adi.Stingray Analog Devices Inc. Stingray beamformer development platform
    %   The adi.Stingray system object is an API to control the
    %   Stingray X/Ku Band Beamforming Developer Platform.
    %
    %   rx = adi.Stingray;
    %   rx = adi.Stingray('uri','ip:192.168.2.1');
    %
    %   <a href="https://wiki.analog.com/resources/eval/developer-kits/x-band-dev-kit">Stingray X/Ku Band Beamforming Developer Platform Wiki</a>
    properties(Nontunable, Hidden)
        ElementToChipChannelMap = [4,3,4,3, 4,3,4,3; 1,2,1,2, 1,2,1,2; 4,3,4,3, 4,3,4,3; 1,2,1,2, 1,2,1,2]; % channel attributes
        ElementToChipMap = [1,1,3,3, 5,5,7,7; 1,1,3,3, 5,5,7,7; 2,2,4,4, 6,6,8,8; 2,2,4,4, 6,6,8,8]; % channel attributes
        SubarrayToChipMap = [1,3,5,7; 2,4,6,8]; % device attributes
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
            % LTC2314
            setupInit@adi.internal.LTC2314(obj);            
        end
    end
end
