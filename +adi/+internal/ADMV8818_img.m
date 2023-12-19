% ADMV8818 2-18 GHz Digitally Tunable High Pass and Low Pass Filter, used as Image Filter on 2-24 GHz XMW RX Platform
%
% IIO Driver: https://wiki.analog.com/resources/tools-software/linux-drivers/iio-filter/admv8818
classdef ADMV8818_img< ...
		adi.common.Rx & ...
		adi.common.Attribute & ...
		adi.common.DebugAttribute & ...
		matlabshared.libiio.base

	% Properties to set
	properties(Hidden)
		%%  ADMV8818_img_LowPass3dBFrequency ADMV8818 Low Pass 3dB Frequency
		%   Configure 3dB cutoff frequency for Low Pass Filter in MHz
		ADMV8818_img_LowPass3dBFrequency = 5500;
		%%  ADMV8818_img_HighPass3dBFrequency ADMV8818 High Pass 3dB Frequency
		%   Configure 3dB cutoff frequency for High Pass Filter in MHz
		ADMV8818_img_HighPass3dBFrequency = 4500;
		%%  ADMV8818_img_BandPass3dBCenterFrequency ADMV8818 Band Pass 3dB Center Frequency
		%   Configure Band Pass Center Frequency for Band Pass Filter in MHz
		ADMV8818_img_BandPassCenterFrequency = 5000;
	end

	properties(Nontunable, Hidden)
		%%  ADMV8818_img_BandPass3dBBandwidth ADMV8818 Band Pass 3dB Bandwidth
		%   Constant 3dB Band Pass Bandwidth for Band Pass Filter in MHz
		ADMV8818_img_BandPass3dBBandwidth = 1000
	end

	properties(Nontunable, Hidden)
		ADMV8818_img_Timeout = Inf;
		ADMV8818_img_kernelBuffersCount = 0;
		ADMV8818_img_dataTypeStr = 'int16';
		ADMV8818_img_phyDevName = 'ADMV8818_img';
		ADMV8818_img_iioDevPHY
		ADMV8818_img_devName = 'iio:device2'
		ADMV8818_img_SamplesPerFrame = 0;
	end

	properties (Hidden, Constant, Logical)
		ADMV8818_img_ComplexData = false;
	end

	properties(Nontunable, Hidden, Constant)
		ADMV8818_img_Type = 'Rx';
		ADMV8818_img_channel_names = {''};
	end

	properties (Hidden, Nontunable, Access = protected)
		ADMV8818_img_isOutput = true;
	end

	methods
		%% Constructor
		function obj = ADMV8818_img(varargin)
			coder.allowpcode('plain');
			obj = obj@matlabshared.libiio.base(varargin{:});
		end
		% Destructor
		function delete(obj)
		end

		% Set Low Pass 3dB Frequency
		function set.ADMV8818_img_LowPass3dBFrequency(obj, value)
			validateattributes(value, { 'double', 'single', 'uint32' }, ...
				{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', ...
				'>=', 2000, '<=', 25000 }, '', 'ADMV8818_img_LowPass3dBFrequency');
			obj.ADMV8818_img_LowPass3dBFrequency = value;
			if obj.ConnectedToDevice
				obj.setAttributeLongLong('altvoltage0', 'filter_low_pass_3db_frequency', int64(value), true, 1000, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Get Low Pass 3dB Frequency
		function result = get.ADMV8818_img_LowPass3dBFrequency(obj)
			result = 0;
			if obj.ConnectedToDevice
				result = obj.getAttributeLongLong('altvoltage0', 'filter_low_pass_3db_frequency', true, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Set High Pass 3dB Frequency
		function set.ADMV8818_img_HighPass3dBFrequency(obj, value)
			validateattributes(value, { 'double', 'single', 'uint32' }, ...
				{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', ...
				'>=', 1000, '<=', 24000 }, '', 'ADMV8818_img_HighPass3dBFrequency');
			obj.ADMV8818_img_HighPass3dBFrequency = value;
			if obj.ConnectedToDevice
				obj.setAttributeLongLong('altvoltage0', 'filter_high_pass_3db_frequency', int64(value), true, 1000, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Get High Pass 3dB Frequency
		function result = get.ADMV8818_img_HighPass3dBFrequency(obj)
			result = 0;
			if obj.ConnectedToDevice
				result = obj.getAttributeLongLong('altvoltage0', 'filter_high_pass_3db_frequency', true, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Set Band Pass 3dB Bandwidth
		function set.ADMV8818_img_BandPass3dBBandwidth(obj, value)
			validateattributes(value, { 'double', 'single', 'uint32' }, ...
				{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', ...
				'>=', 100, '<=', 4000 }, '', 'ADMV8818_img_BandPass3dBBandwidth');
			obj.ADMV8818_img_BandPass3dBBandwidth = value;
			if obj.ConnectedToDevice
				obj.setAttributeLongLong('altvoltage0', 'filter_band_pass_bandwidth_3db_frequency', int64(value), true, 1000, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Get Band Pass 3dB Bandwidth
		function result = get.ADMV8818_img_BandPass3dBBandwidth(obj)
			result = 0;
			if obj.ConnectedToDevice
				result = obj.getAttributeLongLong('altvoltage0', 'filter_band_pass_bandwidth_3db_frequency', true, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Set Band Pass Center Frequency
		function set.ADMV8818_img_BandPassCenterFrequency(obj, value)
			validateattributes(value, { 'double','single','uint32' }, ...
				{ 'real', 'nonnegative', 'scalar', 'finite', 'nonnan', 'nonempty', 'integer', ...
				'>=', obj.ADMV8818_img_HighPass3dBFrequency, '<=', obj.ADMV8818_img_LowPass3dBFrequency }, '', 'ADMV8818_img_BandPassCenterFrequency');
			obj.ADMV8818_img_BandPassCenterFrequency = value;
			if obj.ConnectedToDevice
				obj.setAttributeLongLong('altvoltage0', 'filter_band_pass_center_frequency', int64(value), true, 1000, obj.ADMV8818_img_iioDevPHY);
			end
		end
		% Get Band Pass Center Frequency
		function result = get.ADMV8818_img_BandPassCenterFrequency(obj)
			result = 0;
			if obj.ConnectedToDevice
				result = obj.getAttributeLongLong('altvoltage0', 'filter_band_pass_center_frequency', true, obj.ADMV8818_img_iioDevPHY);
			end
		end
	end

	%% API Functions
	methods (Hidden, Access = protected)
		function setupInit(obj, label)
			% Get the device
			obj.ADMV8818_img_devName = label;
			obj.ADMV8818_img_iioDevPHY = getDev(obj, obj.ADMV8818_img_devName);
			obj.needsTeardown = true;
			obj.ConnectedToDevice = true;
			% Do writes directly to hardware without using set methods.
			% This is required since Simulink support doesn't support
			% modification to nontunable variables at SetupImpl
			obj.setAttributeLongLong('altvoltage0', 'filter_low_pass_3db_frequency', int64(5500), true, 1000, obj.ADMV8818_img_iioDevPHY);
			obj.setAttributeLongLong('altvoltage0', 'filter_high_pass_3db_frequency', int64(4500), true, 1000, obj.ADMV8818_img_iioDevPHY);
			obj.setAttributeLongLong('altvoltage0', 'filter_band_pass_center_frequency', int64(5000), true, 1000, obj.ADMV8818_img_iioDevPHY);
		end
	end

end