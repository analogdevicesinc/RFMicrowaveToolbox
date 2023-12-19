% API to configure RF properties for 2-24GHx XMW TX Platform
%
% See https://wiki.analog.com/resources/eval/developer-kits/2to24ghz-mxfe-rf-front-end

classdef XMW_TX_Platform < adi.internal.ADF4371_fixed & ...
		adi.internal.ADF4371_tunable & ...
		adi.internal.ADMV8818 & ...
		adi.internal.ADRF5020 & ...
		adi.internal.ADRF5730 & ...
		matlabshared.libiio.base

	% Properties to set
	properties
		%% if_freq_MHz Intermediate Frequency in MHz
		% IF generated by MxFE chip
		if_freq_MHz = 4500
		%% output_freq_MHz RF output frequency in MHz
		% Desired output frequency which determines appropriate RF conversion path, tunable LO frequency and BPF center frequency
		output_freq_MHz = 12500
		%% output_freq_range Output frequency range, may be 1 (2-7 GHz) or 0 (7.1-24 GHz)
		% Control signal value to switch which selects appropriate RF conversion path
		output_freq_range = 0
		%% if_attenuation_decimal Attenuation Decimal value (0-63) for Intermediate Frequency
		% Corresponds to attenuation of 0-31.5 dB at output
		if_attenuation_decimal = 0
		%% output_bpf_freq_MHz Center frequency of output Band Pass Filter
		% Automatically sets 3dB low pass and 3dB high pass frequencies for 1000 MHz bandwidth around the center frequency
		output_bpf_freq_MHz = 12500
		%% fixed_pll_freq_MHz Fixed PLL frequency in MHz
		% LO Frequency generated by the Fixed PLL
		fixed_pll_freq_MHz = 18000
		%% tunable_pll_freq_MHz Tunable PLL frequency in MHz
		% LO Frequency generated by the Tunable PLL
		tunable_pll_freq_MHz = 17000
	end

	properties(Nontunable, Hidden)
		Timeout = Inf;
		kernelBuffersCount = 0;
		dataTypeStr = 'int16';
		phyDevName;
		iioDevPHY
		devName;
		SamplesPerFrame = 0;
	end

	properties (Hidden, Constant, Logical)
		ComplexData = false;
	end

	properties(Nontunable, Hidden, Constant)
		Type = 'Rx';
		channel_names = {''};
	end

	properties (Hidden, Nontunable, Access = protected)
		isOutput = true;
	end

	methods
		%% Constructor
		function obj = XMW_TX_Platform(varargin)
			coder.allowpcode('plain');
			obj = obj@matlabshared.libiio.base(varargin{:});
		end
		% Destructor
		function delete(obj)
		end
	end

	%% API Functions
	methods (Hidden, Access = protected)
		function setupImpl(obj)
			% Setup LibIIO
			setupLib(obj);
			% Initialize the pointers
			initPointers(obj);
			getContext(obj);
			setContextTimeout(obj);
			% Initialize all IIO devices
			setupInit(obj);
		end
		function [data,valid] = stepImpl(~)
			data = 0;
			valid = false;
		end
		function setupInit(obj)
			setupInit@adi.internal.ADF4371_fixed(obj, 'iio:device4');
			setupInit@adi.internal.ADF4371_tunable(obj, 'iio:device3');
			setupInit@adi.internal.ADMV8818(obj, 'iio:device1');
			setupInit@adi.internal.ADRF5020(obj, 'iio:device5');
			setupInit@adi.internal.ADRF5730(obj, 'iio:device6');
		end
	end

	methods
		function result = get.output_freq_MHz(obj)
			result = false;
			if obj.ConnectedToDevice
				result = obj.output_freq_MHz;
			end
		end

		function set.output_freq_MHz(obj, value)
			obj.output_freq_MHz = value;
			if obj.output_freq_MHz <= 7000
				obj.output_freq_range = 1;
				obj.tunable_pll_freq_MHz = obj.fixed_pll_freq_MHz - obj.output_freq_MHz + obj.if_freq_MHz;
			elseif obj.output_freq_MHz > 7000
				obj.output_freq_range = 0;
				obj.tunable_pll_freq_MHz = obj.output_freq_MHz + obj.if_freq_MHz;
			else
				obj.output_freq_range = 1;
				obj.tunable_pll_freq_MHz = obj.fixed_pll_freq_MHz - obj.output_freq_MHz +obj.if_freq_MHz;
			end
			obj.output_bpf_freq_MHz = value;
		end

		function result = get.output_freq_range(obj)
			result = false;
			if obj.ConnectedToDevice
				result = obj.CtrlSignalValue;
			end
		end

		function set.output_freq_range(obj, value)
			obj.CtrlSignalValue = value;
		end

		function result = get.output_bpf_freq_MHz(obj)
			result = false;
			if obj.ConnectedToDevice
				result = obj.ADMV8818BandPassCenterFrequency;
			end
		end

		function set.output_bpf_freq_MHz(obj, value)
			obj.ADMV8818LowPass3dBFrequency = value + 500;
			obj.ADMV8818HighPass3dBFrequency = value - 500;
			obj.ADMV8818BandPassCenterFrequency = value;
		end

		function result = get.if_attenuation_decimal(obj)
			result = false;
			if obj.ConnectedToDevice
				result = obj.GPIOAttenuationDecimal;
			end
		end

		function set.if_attenuation_decimal(obj, value)
			obj.GPIOAttenuationDecimal = value;
		end

		function result = get.fixed_pll_freq_MHz(obj)
			result = false;

			if obj.ConnectedToDevice
				result = obj.ADF4371_fixed_Frequency/1000000;
			end
		end

		function set.fixed_pll_freq_MHz(obj, value)
			obj.ADF4371_fixed_Frequency = value*1000000;
		end

		function result = get.tunable_pll_freq_MHz(obj)
			result = false;
			if obj.ConnectedToDevice
				result = obj.ADF4371_tunable_Frequency/1000000;
			end
		end

		function set.tunable_pll_freq_MHz(obj, value)
			obj.ADF4371_tunable_Frequency = value*1000000;
		end
	end

	%% External Dependency Methods
	methods (Hidden, Static)
		function tf = isSupportedContext(bldCfg)
			tf = matlabshared.libiio.ExternalDependency.isSupportedContext(bldCfg);
		end
		function updateBuildInfo(buildInfo, bldCfg)
			% Call the matlabshared.libiio.method first
			matlabshared.libiio.ExternalDependency.updateBuildInfo(buildInfo, bldCfg);
		end
	end
end