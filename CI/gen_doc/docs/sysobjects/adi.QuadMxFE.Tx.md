

<!-- <div class="sysobj_h1">adi.QuadMxFE.Tx</div> -->

<!-- <div class="sysobj_top_desc">
Receive data from Analog Devices AD9361 transceiver
</div> -->

<!-- <div class="sysobj_desc_title">Description</div> -->

<div class="sysobj_desc_txt">
<span>
    The adi.QuadMxFE.Tx System object is a signal sink that can tranmsit<br>    complex data from the QuadMxFE.<br> <br>    tx = adi.QuadMxFE.Tx;<br>    tx = adi.QuadMxFE.Tx('uri','ip:ip:192.168.2.1');<br> <br>    <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/AD9081.pdf">AD9081 Datasheet</a><br>
</span>

</div>

<div class="sysobj_desc_title">Creation</div>

The class can be instantiated in the following way with and without property name value pairs.

```matlab
dev = adi.QuadMxFE.Tx
dev = adi.QuadMxFE.Tx(Name, Value)
```

<div class="sysobj_desc_title">Properties</div>

<div class="sysobj_desc_txt">
<span>
Unless otherwise indicated, properties are non-tunable, which means you cannot change their values after calling the object. Objects lock when you call them, and the release function unlocks them.
<br><br>
If a property is tunable, you can change its value at any time.
<br><br>
For more information on changing property values, see <a href="https://www.mathworks.com/help/matlab/matlab_prog/system-design-in-matlab-using-system-objects.html">System Design in MATLAB Using System Objects.</a>
</span>
</div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipA')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipA">ChannelNCOFrequenciesChipA <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipA">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipB')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipB">ChannelNCOFrequenciesChipB <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipB">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipC')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipC">ChannelNCOFrequenciesChipC <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipC">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipD')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipD">ChannelNCOFrequenciesChipD <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipD">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipA')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipA">MainNCOFrequenciesChipA <span style="text-align:right" class="plus-MainNCOFrequenciesChipA">+</span></button>
  <div class="content content-MainNCOFrequenciesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipB')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipB">MainNCOFrequenciesChipB <span style="text-align:right" class="plus-MainNCOFrequenciesChipB">+</span></button>
  <div class="content content-MainNCOFrequenciesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipC')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipC">MainNCOFrequenciesChipC <span style="text-align:right" class="plus-MainNCOFrequenciesChipC">+</span></button>
  <div class="content content-MainNCOFrequenciesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipD')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipD">MainNCOFrequenciesChipD <span style="text-align:right" class="plus-MainNCOFrequenciesChipD">+</span></button>
  <div class="content content-MainNCOFrequenciesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipA')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipA">ChannelNCOPhasesChipA <span style="text-align:right" class="plus-ChannelNCOPhasesChipA">+</span></button>
  <div class="content content-ChannelNCOPhasesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipB')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipB">ChannelNCOPhasesChipB <span style="text-align:right" class="plus-ChannelNCOPhasesChipB">+</span></button>
  <div class="content content-ChannelNCOPhasesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipC')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipC">ChannelNCOPhasesChipC <span style="text-align:right" class="plus-ChannelNCOPhasesChipC">+</span></button>
  <div class="content content-ChannelNCOPhasesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipD')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipD">ChannelNCOPhasesChipD <span style="text-align:right" class="plus-ChannelNCOPhasesChipD">+</span></button>
  <div class="content content-ChannelNCOPhasesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipA')" class="collapsible-property collapsible-property-MainNCOPhasesChipA">MainNCOPhasesChipA <span style="text-align:right" class="plus-MainNCOPhasesChipA">+</span></button>
  <div class="content content-MainNCOPhasesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipB')" class="collapsible-property collapsible-property-MainNCOPhasesChipB">MainNCOPhasesChipB <span style="text-align:right" class="plus-MainNCOPhasesChipB">+</span></button>
  <div class="content content-MainNCOPhasesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipC')" class="collapsible-property collapsible-property-MainNCOPhasesChipC">MainNCOPhasesChipC <span style="text-align:right" class="plus-MainNCOPhasesChipC">+</span></button>
  <div class="content content-MainNCOPhasesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipD')" class="collapsible-property collapsible-property-MainNCOPhasesChipD">MainNCOPhasesChipD <span style="text-align:right" class="plus-MainNCOPhasesChipD">+</span></button>
  <div class="content content-MainNCOPhasesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOGainScalesChipA')" class="collapsible-property collapsible-property-ChannelNCOGainScalesChipA">ChannelNCOGainScalesChipA <span style="text-align:right" class="plus-ChannelNCOGainScalesChipA">+</span></button>
  <div class="content content-ChannelNCOGainScalesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOGainScalesChipB')" class="collapsible-property collapsible-property-ChannelNCOGainScalesChipB">ChannelNCOGainScalesChipB <span style="text-align:right" class="plus-ChannelNCOGainScalesChipB">+</span></button>
  <div class="content content-ChannelNCOGainScalesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOGainScalesChipC')" class="collapsible-property collapsible-property-ChannelNCOGainScalesChipC">ChannelNCOGainScalesChipC <span style="text-align:right" class="plus-ChannelNCOGainScalesChipC">+</span></button>
  <div class="content content-ChannelNCOGainScalesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOGainScalesChipD')" class="collapsible-property collapsible-property-ChannelNCOGainScalesChipD">ChannelNCOGainScalesChipD <span style="text-align:right" class="plus-ChannelNCOGainScalesChipD">+</span></button>
  <div class="content content-ChannelNCOGainScalesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in transmit path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('NCOEnablesChipA')" class="collapsible-property collapsible-property-NCOEnablesChipA">NCOEnablesChipA <span style="text-align:right" class="plus-NCOEnablesChipA">+</span></button>
  <div class="content content-NCOEnablesChipA" style="display: none;">
    <p style="padding: 0px;">Vector of logicals which enabled individual NCOs in channel interpolators</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('NCOEnablesChipB')" class="collapsible-property collapsible-property-NCOEnablesChipB">NCOEnablesChipB <span style="text-align:right" class="plus-NCOEnablesChipB">+</span></button>
  <div class="content content-NCOEnablesChipB" style="display: none;">
    <p style="padding: 0px;">Vector of logicals which enabled individual NCOs in channel interpolators</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('NCOEnablesChipC')" class="collapsible-property collapsible-property-NCOEnablesChipC">NCOEnablesChipC <span style="text-align:right" class="plus-NCOEnablesChipC">+</span></button>
  <div class="content content-NCOEnablesChipC" style="display: none;">
    <p style="padding: 0px;">Vector of logicals which enabled individual NCOs in channel interpolators</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('NCOEnablesChipD')" class="collapsible-property collapsible-property-NCOEnablesChipD">NCOEnablesChipD <span style="text-align:right" class="plus-NCOEnablesChipD">+</span></button>
  <div class="content content-NCOEnablesChipD" style="display: none;">
    <p style="padding: 0px;">Vector of logicals which enabled individual NCOs in channel interpolators</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('UpdateDACFullScaleCurrent')" class="collapsible-property collapsible-property-UpdateDACFullScaleCurrent">UpdateDACFullScaleCurrent <span style="text-align:right" class="plus-UpdateDACFullScaleCurrent">+</span></button>
  <div class="content content-UpdateDACFullScaleCurrent" style="display: none;">
    <p style="padding: 0px;">At initialization update DAC full scale current</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('DACFullScaleCurrentuA')" class="collapsible-property collapsible-property-DACFullScaleCurrentuA">DACFullScaleCurrentuA <span style="text-align:right" class="plus-DACFullScaleCurrentuA">+</span></button>
  <div class="content content-DACFullScaleCurrentuA" style="display: none;">
    <p style="padding: 0px;">DAC full scale current in microamps. Only used when UpdateDACFullScaleCurrent is set.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('SamplesPerFrame')" class="collapsible-property collapsible-property-SamplesPerFrame">SamplesPerFrame <span style="text-align:right" class="plus-SamplesPerFrame">+</span></button>
  <div class="content content-SamplesPerFrame" style="display: none;">
    <p style="padding: 0px;">Number of samples per frame, specified as an even positive integer from 2 to 16,777,216. Using values less than 3660 can yield poor performance.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnableResampleFilters')" class="collapsible-property collapsible-property-EnableResampleFilters">EnableResampleFilters <span style="text-align:right" class="plus-EnableResampleFilters">+</span></button>
  <div class="content content-EnableResampleFilters" style="display: none;">
    <p style="padding: 0px;">Enable interpolation (TX) or decimation (RX) by 2 when enabled to correct interface rate to 125 MS/s. This will scale the input and output data length by either 1/2 (RX) or 2 (TX).</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('CalibrationBoardAttached')" class="collapsible-property collapsible-property-CalibrationBoardAttached">CalibrationBoardAttached <span style="text-align:right" class="plus-CalibrationBoardAttached">+</span></button>
  <div class="content content-CalibrationBoardAttached" style="display: none;">
    <p style="padding: 0px;"></p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnabledChannels')" class="collapsible-property collapsible-property-EnabledChannels">EnabledChannels <span style="text-align:right" class="plus-EnabledChannels">+</span></button>
  <div class="content content-EnabledChannels" style="display: none;">
    <p style="padding: 0px;">Indexs of channels to be enabled. Input should be a [1xN] vector with the indexes of channels to be enabled. Order is irrelevant</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('uri')" class="collapsible-property collapsible-property-uri">uri <span style="text-align:right" class="plus-uri">+</span></button>
  <div class="content content-uri" style="display: none;">
    <p style="padding: 0px;">Hostname or IP address of remote libIIO deviceHelp for adi.QuadMxFE.Tx/uri is inherited from superclass matlabshared.libiio.base</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('DataSource')" class="collapsible-property collapsible-property-DataSource">DataSource <span style="text-align:right" class="plus-DataSource">+</span></button>
  <div class="content content-DataSource" style="display: none;">
    <p style="padding: 0px;">Data source, specified as one of the following: 'DMA' — Specify the host as the source of the data. 'DDS' — Specify the DDS on the radio hardware as the source of the data. In this case, each channel has two additive tones.Help for adi.QuadMxFE.Tx/DataSource is inherited from superclass adi.common.DDS</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('DDSFrequencies')" class="collapsible-property collapsible-property-DDSFrequencies">DDSFrequencies <span style="text-align:right" class="plus-DDSFrequencies">+</span></button>
  <div class="content content-DDSFrequencies" style="display: none;">
    <p style="padding: 0px;">Frequencies values in Hz of the DDS tone generators. For complex data devices the input is a [2xN] matrix where N is the available channels on the board. For complex data devices this is at most max(EnabledChannels)*2. For non-complex data devices this is at most max(EnabledChannels). If N < this upper limit, other DDSs are not set.Help for adi.QuadMxFE.Tx/DDSFrequencies is inherited from superclass adi.common.DDS</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('DDSScales')" class="collapsible-property collapsible-property-DDSScales">DDSScales <span style="text-align:right" class="plus-DDSScales">+</span></button>
  <div class="content content-DDSScales" style="display: none;">
    <p style="padding: 0px;">Scale of DDS tones in range [0,1]. For complex data devices the input is a [2xN] matrix where N is the available channels on the board. For complex data devices this is at most max(EnabledChannels)*2. For non-complex data devices this is at most max(EnabledChannels). If N < this upper limit, other DDSs are not set.Help for adi.QuadMxFE.Tx/DDSScales is inherited from superclass adi.common.DDS</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('DDSPhases')" class="collapsible-property collapsible-property-DDSPhases">DDSPhases <span style="text-align:right" class="plus-DDSPhases">+</span></button>
  <div class="content content-DDSPhases" style="display: none;">
    <p style="padding: 0px;">Phases of DDS tones in range [0,360000]. For complex data devices the input is a [2xN] matrix where N is the available channels on the board. For complex data devices this is at most max(EnabledChannels)*2. For non-complex data devices this is at most max(EnabledChannels). If N < this upper limit, other DDSs are not set.Help for adi.QuadMxFE.Tx/DDSPhases is inherited from superclass adi.common.DDS</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnableCyclicBuffers')" class="collapsible-property collapsible-property-EnableCyclicBuffers">EnableCyclicBuffers <span style="text-align:right" class="plus-EnableCyclicBuffers">+</span></button>
  <div class="content content-EnableCyclicBuffers" style="display: none;">
    <p style="padding: 0px;">Enable Cyclic Buffers, configures transmit buffers to be cyclic, which makes them continuously repeatHelp for adi.QuadMxFE.Tx/EnableCyclicBuffers is inherited from superclass adi.common.DDS</p>
  </div>
  </div>

<div class="sysobj_desc_title">Example Usage</div>

```

%% Configure device
tx = adi.QuadMxFE.Tx;
tx.uri = "ip:analog.local";
tx.DataSource = 'DMA';
tx.EnableCyclicBuffers = true;
tx.EnabledChannels = 1;

%% Generate tone
amplitude = 2^15; frequency = 0.12e6;
swv1 = dsp.SineWave(amplitude, frequency);
swv1.SamplesPerFrame = 2^14;

swv1.SampleRate = tx.SamplingRate;
y = swv1();

%% Send
tx(y);

```