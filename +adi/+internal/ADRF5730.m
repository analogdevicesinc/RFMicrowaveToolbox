% ADRF5730 Silicon 6-Bit Digital Attenuator (0-31.5dB), parallel control implemented using one-bit-adc-dac driver
%
% IIO Driver: https://github.com/analogdevicesinc/linux/blob/master/drivers/iio/addac/one-bit-adc-dac.c
classdef ADRF5730 < ...
		adi.common.Rx & ...
		adi.common.Attribute & ...
		adi.common.DebugAttribute & ...
		matlabshared.libiio.base

	% Properties to set
	properties(Hidden)
		%%  GPIOAttenuationDecimal ADRF5730 Attenuation Decimal value
		%   Configure Attenuation Decimal value for ADRF5730 controlled by 6-bit GPIO
		GPIOAttenuationDecimal = 0;
	end

	properties(Hidden)
		ADRF5730_atten_dB = 0;
		ADRF5730_atten_decimal = 0;
	end

	properties(Nontunable, Hidden)
		ADRF5730_Timeout = Inf;
		ADRF5730_kernelBuffersCount = 0;
		ADRF5730_dataTypeStr = 'int16';
		ADRF5730_phyDevName = 'one-bit-adc-dac';
		ADRF5730_iioDevPHY
		ADRF5730_devName = 'iio:device6';
		ADRF5730_SamplesPerFrame = 0;
	end

	properties (Hidden, Constant, Logical)
		ADRF5730_ComplexData = false;
	end

	properties(Nontunable, Hidden, Constant)
		ADRF5730_Type = 'Rx';
		ADRF5730_channel_names = {''};
	end

	properties (Hidden, Nontunable, Access = protected)
		ADRF5730_isOutput = true;
	end

	methods
		%% Constructor
		function obj = ADRF5730(varargin)
			coder.allowpcode('plain');
			obj = obj@matlabshared.libiio.base(varargin{:});
		end
		% Destructor
		function delete(obj)
		end
		% Set GPIO Attenuation
		function set.GPIOAttenuationDecimal(obj, value)
			validateattributes(value, { 'double', 'single', 'uint32' }, ...
				{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', ...
				'>=', 0, '<=', 63 }, '', 'GPIOAttenuationDecimal');
			obj.GPIOAttenuationDecimal = value;
			obj.ADRF5730_atten_decimal = value;
			obj.ADRF5730_atten_dB = fix(value/2);
			% Set D0 based on whether or not the Attenuation Decimal value is odd (since odd Attenuation Decimal value / 2 gives an Attenuation dB value ending in 0.5)
			if (mod(value, 2) ~= 0)
				D0 = 1;
			else
				D0 = 0;
			end
			% Mask out each of the remaining bits from the Attenuation Decimal value to determine D5-D1
			D5 = int16(bitsrl(int16(bitand(obj.ADRF5730_atten_decimal, bitsll(1, 5))), 5));
			D4 = int16(bitsrl(int16(bitand(obj.ADRF5730_atten_decimal, bitsll(1, 4))), 4));
			D3 = int16(bitsrl(int16(bitand(obj.ADRF5730_atten_decimal, bitsll(1, 3))), 3));
			D2 = int16(bitsrl(int16(bitand(obj.ADRF5730_atten_decimal, bitsll(1, 2))), 2));
			D1 = int16(bitsrl(int16(bitand(obj.ADRF5730_atten_decimal, bitsll(1, 1))), 1));
			if obj.ConnectedToDevice
				obj.setAttributeRAW('voltage5', 'raw', num2str(D5), true, obj.ADRF5730_iioDevPHY);
				obj.setAttributeRAW('voltage4', 'raw', num2str(D4), true, obj.ADRF5730_iioDevPHY);
				obj.setAttributeRAW('voltage3', 'raw', num2str(D3), true, obj.ADRF5730_iioDevPHY);
				obj.setAttributeRAW('voltage2', 'raw', num2str(D2), true, obj.ADRF5730_iioDevPHY);
				obj.setAttributeRAW('voltage1', 'raw', num2str(D1), true, obj.ADRF5730_iioDevPHY);
				obj.setAttributeRAW('voltage0', 'raw', num2str(D0), true, obj.ADRF5730_iioDevPHY);
			end
		end
		% Get GPIO Attenuation
		function result = get.GPIOAttenuationDecimal(obj)
			result = 0;
			if obj.ConnectedToDevice
				atten_D5_dB = 0;
				atten_D4_dB = 0;
				atten_D3_dB = 0;
				atten_D2_dB = 0;
				atten_D1_dB = 0;
				atten_D0_dB = 0;
				D5 = str2num(obj.getAttributeRAW('voltage5', 'raw', true, obj.ADRF5730_iioDevPHY));
				D4 = str2num(obj.getAttributeRAW('voltage4', 'raw', true, obj.ADRF5730_iioDevPHY));
				D3 = str2num(obj.getAttributeRAW('voltage3', 'raw', true, obj.ADRF5730_iioDevPHY));
				D2 = str2num(obj.getAttributeRAW('voltage2', 'raw', true, obj.ADRF5730_iioDevPHY));
				D1 = str2num(obj.getAttributeRAW('voltage1', 'raw', true, obj.ADRF5730_iioDevPHY));
				D0 = str2num(obj.getAttributeRAW('voltage0', 'raw', true, obj.ADRF5730_iioDevPHY));
				if D5 == 1
					atten_D5_dB = 16;
				end
				if D4 == 1
					atten_D4_dB = 8;
				end
				if D3 == 1
					atten_D3_dB = 4;
				end
				if D2 == 1
					atten_D2_dB = 2;
				end
				if D1 == 1
					atten_D1_dB = 1;
				end
				if D0 == 1
					atten_D0_dB = 0.5;
				end
				obj.ADRF5730_atten_dB = atten_D5_dB + atten_D4_dB + atten_D3_dB + atten_D2_dB + atten_D1_dB + atten_D0_dB;
				obj.ADRF5730_atten_decimal = obj.ADRF5730_atten_dB * 2;
				result = obj.ADRF5730_atten_decimal;
			end
		end
	end

	%% API Functions
	methods (Hidden, Access = protected)
		function setupInit(obj, label)
			% Get the device
			obj.ADRF5730_devName = label;
			obj.ADRF5730_iioDevPHY = getDev(obj, obj.ADRF5730_devName);
			obj.needsTeardown = true;
			obj.ConnectedToDevice = true;
			% Do writes directly to hardware without using set methods.
			% This is required since Simulink support doesn't support
			% modification to nontunable variables at SetupImpl
			obj.setAttributeRAW('voltage5', 'raw', num2str(0), true, obj.ADRF5730_iioDevPHY);
			obj.setAttributeRAW('voltage4', 'raw', num2str(0), true, obj.ADRF5730_iioDevPHY);
			obj.setAttributeRAW('voltage3', 'raw', num2str(0), true, obj.ADRF5730_iioDevPHY);
			obj.setAttributeRAW('voltage2', 'raw', num2str(0), true, obj.ADRF5730_iioDevPHY);
			obj.setAttributeRAW('voltage1', 'raw', num2str(0), true, obj.ADRF5730_iioDevPHY);
			obj.setAttributeRAW('voltage0', 'raw', num2str(0), true, obj.ADRF5730_iioDevPHY);
		end
	end

end
