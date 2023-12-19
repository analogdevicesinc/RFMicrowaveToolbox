% ADRF5740 Silicon 4-Bit Digital Attenuator (0-22dB), parallel control implemented using one-bit-adc-dac driver
%
% IIO Driver: https://github.com/analogdevicesinc/linux/blob/master/drivers/iio/addac/one-bit-adc-dac.c
classdef ADRF5740 < ...
		adi.common.Rx & ...
		adi.common.Attribute & ...
		adi.common.DebugAttribute & ...
		matlabshared.libiio.base

	% Properties to set
	properties(Hidden)
		%%  GPIOAttenuationDecibel ADRF5740 Decibel Attenuation value
		%   Configure Decibel Attenuation value for ADRF5740 controlled by 4-bit GPIO
		GPIOAttenuationDecibel = 0;
	end

	properties(Hidden)
		ADRF5740_atten_dB = 0;
	end

	properties(Nontunable, Hidden)
		ADRF5740_Timeout = Inf;
		ADRF5740_kernelBuffersCount = 0;
		ADRF5740_dataTypeStr = 'int16';
		ADRF5740_phyDevName = 'one-bit-adc-dac';
		ADRF5740_iioDevPHY
		ADRF5740_devName = 'iio:device6';
		ADRF5740_SamplesPerFrame = 0;
	end

	properties (Hidden, Constant, Logical)
		ADRF5740_ComplexData = false;
	end

	properties(Nontunable, Hidden, Constant)
		ADRF5740_Type = 'Rx';
		ADRF5740_channel_names = {''};
	end

	properties (Hidden, Nontunable, Access = protected)
		ADRF5740_isOutput = true;
	end

	methods
		%% Constructor
		function obj = ADRF5740(varargin)
			coder.allowpcode('plain');
			obj = obj@matlabshared.libiio.base(varargin{:});
		end
		% Destructor
		function delete(obj)
		end
		% Set GPIO Attenuation
		function set.GPIOAttenuationDecibel(obj, value)
			validateattributes(value, { 'double', 'single', 'uint32' }, ...
				{ 'real', 'even', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer' }, ...
				'', 'GPIOAttenuationDecibel');
			obj.GPIOAttenuationDecibel = value;
			obj.ADRF5740_atten_dB = value;
			switch obj.ADRF5740_atten_dB
				case 0
					D5 = 0;
					D4 = 0;
					D3 = 0;
					D2 = 0;
				case 2
					D5 = 0;
					D4 = 0;
					D3 = 0;
					D2 = 1;
				case 4
					D5 = 0;
					D4 = 0;
					D3 = 1;
					D2 = 0;
				case 6
					D5 = 0;
					D4 = 0;
					D3 = 1;
					D2 = 1;
				case 8
					D5 = 0;
					D4 = 1;
					D3 = 0;
					D2 = 0;
				case 10
					D5 = 0;
					D4 = 1;
					D3 = 0;
					D2 = 1;
				case 12
					D5 = 0;
					D4 = 1;
					D3 = 1;
					D2 = 0;
				case 14
					D5 = 0;
					D4 = 1;
					D3 = 1;
					D2 = 1;
				case 16
					D5 = 1;
					D4 = 1;
					D3 = 0;
					D2 = 0;
				case 18
					D5 = 1;
					D4 = 1;
					D3 = 0;
					D2 = 1;
				case 20
					D5 = 1;
					D4 = 1;
					D3 = 1;
					D2 = 0;
				case 22
					D5 = 1;
					D4 = 1;
					D3 = 1;
					D2 = 1;
				otherwise
					D5 = 0;
					D4 = 0;
					D3 = 0;
					D2 = 0;
			end
			if obj.ConnectedToDevice
				obj.setAttributeRAW('voltage3', 'raw', num2str(D5), true, obj.ADRF5740_iioDevPHY);
				obj.setAttributeRAW('voltage2', 'raw', num2str(D4), true, obj.ADRF5740_iioDevPHY);
				obj.setAttributeRAW('voltage1', 'raw', num2str(D3), true, obj.ADRF5740_iioDevPHY);
				obj.setAttributeRAW('voltage0', 'raw', num2str(D2), true, obj.ADRF5740_iioDevPHY);
			end
		end
		% Get GPIO Attenuation
		function result = get.GPIOAttenuationDecibel(obj)
			result = 0;
			if obj.ConnectedToDevice
				D5 = str2num(obj.getAttributeRAW('voltage3', 'raw', true, obj.ADRF5740_iioDevPHY));
				D4 = str2num(obj.getAttributeRAW('voltage2', 'raw', true, obj.ADRF5740_iioDevPHY));
				D3 = str2num(obj.getAttributeRAW('voltage1', 'raw', true, obj.ADRF5740_iioDevPHY));
				D2 = str2num(obj.getAttributeRAW('voltage0', 'raw', true, obj.ADRF5740_iioDevPHY));
				dig_ctrl_input = int16(bitshift(D5, 3) | bitshift(D4, 2) | bitshift(D3, 1) | bitshift(D2, 0));
				switch dig_ctrl_input
					case 0b0000
						obj.ADRF5740_atten_dB = 0.0;
					case 0b0001
						obj.ADRF5740_atten_dB = 2.0;
					case 0b0010
						obj.ADRF5740_atten_dB = 4.0;
					case 0b0011
						obj.ADRF5740_atten_dB = 6.0;
					case 0b0100
						obj.ADRF5740_atten_dB = 8.0;
					case 0b0101
						obj.ADRF5740_atten_dB = 10.0;
					case 0b0110
						obj.ADRF5740_atten_dB = 12.0;
					case 0b0111
						obj.ADRF5740_atten_dB = 14.0;
					case 0b1100
						obj.ADRF5740_atten_dB = 16.0;
					case 0b1101
						obj.ADRF5740_atten_dB = 18.0;
					case 0b1110
						obj.ADRF5740_atten_dB = 20.0;
					case 0b1111
						obj.ADRF5740_atten_dB = 22.0;
					otherwise
						obj.ADRF5740_atten_dB = 0;
				end
				result = obj.ADRF5740_atten_dB;
			end
		end
	end

	%% API Functions
	methods (Hidden, Access = protected)
		function setupInit(obj, label)
			% Get the device
			obj.ADRF5740_devName = label;
			obj.ADRF5740_iioDevPHY = getDev(obj, obj.ADRF5740_devName);
			obj.needsTeardown = true;
			obj.ConnectedToDevice = true;
			% Do writes directly to hardware without using set methods.
			% This is required sine Simulink support doesn't support
			% modification to nontunable variables at SetupImpl
			%obj.GPIOAttenuationDecibel = 0;
			obj.setAttributeRAW('voltage3', 'raw', num2str(0), true, obj.ADRF5740_iioDevPHY);
			obj.setAttributeRAW('voltage2', 'raw', num2str(0), true, obj.ADRF5740_iioDevPHY);
			obj.setAttributeRAW('voltage1', 'raw', num2str(0), true, obj.ADRF5740_iioDevPHY);
			obj.setAttributeRAW('voltage0', 'raw', num2str(0), true, obj.ADRF5740_iioDevPHY);
		end
	end

end
