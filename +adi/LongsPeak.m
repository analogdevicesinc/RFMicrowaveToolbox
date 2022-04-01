classdef LongsPeak < adi.internal.ADAR300x & ...
        adi.internal.ADMV4420 & ...
        adi.internal.ADRF5720 & ...
        adi.internal.ADL5240 & ...
        adi.internal.AD5760
    %LongsPeak: Ka-Band Beamformer Development Kit
    %   This is at 16x16 antenna per tile system. Therefore we have the
    %   following enumerations:
    %   - 256 antennas
    %   - 64 ADAR3002s
    %   - 512 phase and gain controls
    properties (Nontunable)
    end
    
    properties(Nontunable, Hidden)
        ArrayMapInternal = [...
            1:4,     9:12;...
            5:8,    13:16;...
            ...
            17:20,  25:28;...
            21:24,  29:32;...
            ...
            33:36,  41:44;...
            37:40,  45:48;...
            ...
            49:52,  57:60;...
            53:56,  61:64;...
            ];
    end
    
    properties(Hidden)
        deviceNames = {...
            'adar3002_csb_0_0',...
            'adar3002_csb_0_2',...
            'adar3002_csb_0_3',...
            'adar3002_csb_0_4',...
            'adar3002_csb_0_5',...
            'adar3002_csb_0_6',...
            'adar3002_csb_0_8',...
            'adar3002_csb_0_9'};
    end
    
    methods
        %% Constructor
        function obj = LongsPeak(varargin)
            i = 1;
            map = zeros(16,16);
            for d = 0:2:15
                row = 1;
                for c = 1:8
                    for a=1:2
                        col = 1;
                        for b=1:2
                            map(row,col+d) = i;
                            i = i + 1;
                            col = col + 1;
                        end
                        row = row + 1;
                    end
                end
            end
            coder.allowpcode('plain');
            obj = obj@adi.internal.ADAR300x(varargin{:});

            % Call ADMV4420 constructor
            DownCnvDeviceNames = {'admv4420_CSB1','admv4420_CSB2'};
            obj = obj@adi.internal.ADMV4420('DownCnvDeviceNames',DownCnvDeviceNames);
            
            % Call ADRF5720 constructor
            ADRF5720DeviceNames = {'adrf5720_LE1','adrf5720_LE2'};
            obj = obj@adi.internal.ADRF5720('ADRF5720DeviceNames',ADRF5720DeviceNames);

            % Call ADL5240 constructor
            ADL5240DeviceNames = {'adl5240_LE1','adl5240_LE2'};
            obj = obj@adi.internal.ADL5240('ADL5240DeviceNames',ADL5240DeviceNames);

            % Call AD5760 constructor
            AD5760DeviceNames = {'ad5760_SYNC1','ad5760_SYNC2'};
            obj = obj@adi.internal.AD5760('AD5760DeviceNames',AD5760DeviceNames);

            obj.ArrayMapInternal = map;
            obj.deviceNames = {};
            for k=0:3
                for g=0:15
                    obj.deviceNames = [obj.deviceNames(:)',...
                        {sprintf('adar3002_csb_%d_%d',k,g)}];
                end
            end
            % Set defaults
            obj.updateDefaultDims();
        end
        % Destructor
        function delete(obj)
        end
        % Sets
        function Set.ArrayMap(obj,value)
            obj.ArrayMapInternal = value;
        end
        function value = Get.ArrayMap(obj)
            value = obj.ArrayMapInternal;
        end
    end

    methods (Hidden, Access = protected)
        function setupInit(obj)
            setupInit@adi.internal.ADAR300x(obj);
            setupInit@adi.internal.ADMV4420(obj);
            setupInit@adi.internal.ADRF5720(obj);
            setupInit@adi.internal.ADL5240(obj);
            setupInit@adi.internal.AD5760(obj);
        end
    end
end



