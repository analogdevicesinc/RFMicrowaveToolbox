% ADRF5020 Silicon SPDT Switch implemented using one-bit-adc-dac driver, used as Input Switch on 2-24 GHz XMW RX Platform
%
% IIO Driver: https://github.com/analogdevicesinc/linux/blob/master/drivers/iio/addac/one-bit-adc-dac.c
classdef ADRF5020_input < ...
		adi.common.Rx & ...
		adi.common.Attribute & ...
		adi.common.DebugAttribute & ...
		matlabshared.libiio.base

	% Properties to set
	properties(Hidden)
		%%  ADRF5020_input_CtrlSignalValue ADRF5020 Control Signal Value
		%   Configure control signal voltage for ADRF5020
		ADRF5020_input_CtrlSignalValue = 0;
	end

	properties(Nontunable, Hidden)
		ADRF5020_input_Timeout = Inf;
		ADRF5020_input_kernelBuffersCount = 0;
		ADRF5020_input_dataTypeStr = 'int16';
		ADRF5020_input_phyDevName = 'one-bit-adc-dac';
		ADRF5020_input_iioDevPHY
		ADRF5020_input_devName = 'iio:device5';
		ADRF5020_input_SamplesPerFrame = 0;
	end

	properties (Hidden, Constant, Logical)
		ADRF5020_input_ComplexData = false;
	end

	properties(Nontunable, Hidden, Constant)
		ADRF5020_input_Type = 'Rx';
		ADRF5020_input_channel_names = {''};
	end

	properties (Hidden, Nontunable, Access = protected)
		ADRF5020_input_isOutput = true;
	end

	methods
		%% Constructor
		function obj = ADRF5020_input(varargin)
			coder.allowpcode('plain');
			obj = obj@matlabshared.libiio.base(varargin{:});
		end
		% Destructor
		function delete(obj)
		end
		% Set Control Signal Value
		function set.ADRF5020_input_CtrlSignalValue(obj, value)
			obj.ADRF5020_input_CtrlSignalValue = value;
			if obj.ConnectedToDevice
				obj.setAttributeRAW('voltage0', 'raw', num2str(value), true, obj.ADRF5020_input_iioDevPHY);
			end
		end
		% Get Control Signal Value
		function result = get.ADRF5020_input_CtrlSignalValue(obj)
			result = 0;
			if obj.ConnectedToDevice
				result = obj.getAttributeRAW('voltage0', 'raw', true, obj.ADRF5020_input_iioDevPHY);
			end
		end
	end

	%% API Functions
	methods (Hidden, Access = protected)
		function setupInit(obj, label)
			% Get the device
			obj.ADRF5020_input_devName = label;
			obj.ADRF5020_input_iioDevPHY = getDev(obj, obj.ADRF5020_input_devName);
			obj.needsTeardown = true;
			obj.ConnectedToDevice = true;
			% Do writes directly to hardware without using set methods.
			% This is required since Simulink support doesn't support
			% modification to nontunable variables at SetupImpl
			obj.setAttributeRAW('voltage0', 'raw', num2str(obj.ADRF5020_input_CtrlSignalValue), true, obj.ADRF5020_input_iioDevPHY);
		end
	end

end
