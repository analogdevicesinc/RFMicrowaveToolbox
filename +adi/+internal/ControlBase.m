classdef ControlBase < adi.common.Attribute & ...
        adi.common.DebugAttribute & adi.common.Rx & ...
        matlabshared.libiio.base
    %CONTROLBASE Common based for control only devices (no buffers)

    properties(Nontunable, Hidden)
        kernelBuffersCount = 0;
        dataTypeStr = 'int16';
        SamplesPerFrame = 0;
        devName = '';
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
        function obj = ControlBase(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
        end
    end
end

