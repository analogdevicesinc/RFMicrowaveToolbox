% ADF4371 Wideband Synthesizer with Integrated VCO, provides tunable LO for 2-24 GHz XMW TX/RX Platform
%
% IIO Driver: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-pll/adf4371
classdef ADF4371_tunable < ...
		adi.common.Rx & ...
		adi.common.Attribute & ...
		adi.common.DebugAttribute & ...
		matlabshared.libiio.base

	% Properties to set
	properties(Hidden)
		%%  ADF4371_tunable_RFChannel ADF4371 Channel
		%   Configure programmable divider for ADF4371
		%   Options: 'RF16x' or 'RF32x'
		ADF4371_tunable_RFChannel = 'RF32x';
		%%  ADF4371_tunable_Frequency ADF4371 Frequency
		%   Configure ADF4371 output frequency
		%   Allowed range:
		%   'RF16x': >= 8GHz, <= 16 GHz
		%   'RF32x': >= 16GHz, <= 32 GHz
		ADF4371_tunable_Frequency = 18000000000;
		%%  ADF4371_tunable_Frequency ADF4371 phase
		%   Configure ADF4371 output phase in milli-degrees
		%   Range: 0-359999
		ADF4371_tunable_Phase = 359999;
	end

	properties (Hidden)
		ADF4371_tunable_Channel = 'altvoltage0'
	end

	properties(Nontunable, Hidden)
		ADF4371_tunable_Timeout = Inf;
		ADF4371_tunable_kernelBuffersCount = 0;
		ADF4371_tunable_dataTypeStr = 'int16';
		ADF4371_tunable_phyDevName = 'adf4371';
		ADF4371_tunable_devName = 'iio:device4';
		ADF4371_tunable_iioDevPHY
		ADF4371_tunable_SamplesPerFrame = 0;
	end

	properties (Hidden, Constant, Logical)
		ADF4371_tunable_ComplexData = false;
	end

	properties(Nontunable, Hidden, Constant)
		ADF4371_tunable_Type = 'Rx';
		ADF4371_tunable_channel_names = {''};
	end

	properties (Hidden, Nontunable, Access = protected)
		ADF4371_tunable_isOutput = false;
	end

	methods
		%% Constructor
		function obj = ADF4371_tunable(varargin)
			coder.allowpcode('plain');
			obj = obj@matlabshared.libiio.base(varargin{:});
		end
		% Destructor
		function delete(obj)
		end

		function set.ADF4371_tunable_RFChannel(obj, value)
			obj.ADF4371_tunable_RFChannel = value;
			if obj.ConnectedToDevice
				switch value
					% inverted logic to enable the correct channel
					case 'RF16x'
						obj.setAttributeBool('altvoltage0', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
						obj.setAttributeBool('altvoltage1', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
						obj.setAttributeBool('altvoltage2', 'powerdown', false, true, obj.ADF4371_tunable_iioDevPHY);
						obj.setAttributeBool('altvoltage3', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
						obj.ADF4371_tunable_Channel = 'altvoltage2';
					case 'RF32x'
						obj.setAttributeBool('altvoltage0', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
						obj.setAttributeBool('altvoltage1', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
						obj.setAttributeBool('altvoltage2', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
						obj.setAttributeBool('altvoltage3', 'powerdown', false, true, obj.ADF4371_tunable_iioDevPHY);
						obj.ADF4371_tunable_Channel = 'altvoltage3';
					otherwise
						error('Invalid setting chosen for ADF4371_tunable_RFChannel');
				end
			end
		end

		function set.ADF4371_tunable_Frequency(obj, value)
			switch obj.ADF4371_tunable_RFChannel
				case 'RF16x'
					validateattributes( obj.ADF4371_tunable_Frequency, { 'double','single', 'uint32' }, ...
						{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer',...
						'>=', 8000000000, '<=', 16000000000 },'' , 'ADF4371_tunable_Frequency');
				case 'RF32x'
					validateattributes( obj.ADF4371_tunable_Frequency,{ 'double','single', 'uint32' }, ...
						{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer',...
						'>=', 16000000000, '<=', 32000000000 }, '' , 'ADF4371_tunable_Frequency');
			end
			obj.ADF4371_tunable_Frequency = value;
			if obj.ConnectedToDevice
				obj.setAttributeLongLong('altvoltage0', 'frequency', (value./4), true, 0, obj.ADF4371_tunable_iioDevPHY);
			end
		end

		function set.ADF4371_tunable_Phase(obj, value)
			validateattributes( obj.ADF4371_tunable_Phase, { 'double','single', 'uint32' }, ...
				{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', '>=', 0, '<=', 359999 }, ...
				'', 'ADF4371_tunable_Phase');
			obj.ADF4371_tunable_Phase = value;
			if obj.ConnectedToDevice
				obj.setAttributeLongLong('altvoltage0', 'phase', value, true, 1, obj.ADF4371_tunable_iioDevPHY);
			end
		end

		function set.ADF4371_tunable_Channel(obj, value)
			obj.ADF4371_tunable_Channel = value;
		end
	end

	%% API Functions
	methods (Hidden, Access = protected)
		function setupInit(obj, label)
			% Get the device
			obj.ADF4371_tunable_devName = label;
			obj.ADF4371_tunable_iioDevPHY = getDev(obj, obj.ADF4371_tunable_devName);
			obj.needsTeardown = true;
			obj.ConnectedToDevice = true;
			% Do writes directly to hardware without using set methods.
			% This is required since Simulink support doesn't support
			% modification to nontunable variables at SetupImpl
			switch obj.ADF4371_tunable_RFChannel
				case 'RF16x'
					obj.setAttributeBool('altvoltage2', 'powerdown', false, true, obj.ADF4371_tunable_iioDevPHY);
					obj.ADF4371_tunable_Channel = 'altvoltage2';
				case 'RF32x'
					obj.setAttributeBool('altvoltage3', 'powerdown', false, true, obj.ADF4371_tunable_iioDevPHY);
					obj.ADF4371_tunable_Channel = 'altvoltage3';
				otherwise
					error('Invalid setting chosen for ADF4371_tunable_RFChannel');
			end
			obj.setAttributeBool('altvoltage0', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
			obj.setAttributeBool('altvoltage1', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
			obj.setAttributeBool('altvoltage2', 'powerdown', false, true, obj.ADF4371_tunable_iioDevPHY);
			obj.setAttributeBool('altvoltage3', 'powerdown', true, true, obj.ADF4371_tunable_iioDevPHY);
			obj.setAttributeLongLong('altvoltage0', 'frequency', (18000000000/4), true, 0, obj.ADF4371_tunable_iioDevPHY);
			obj.setAttributeLongLong('altvoltage0', 'phase', obj.ADF4371_tunable_Phase, true, 1, obj.ADF4371_tunable_iioDevPHY);
		end
	end

end