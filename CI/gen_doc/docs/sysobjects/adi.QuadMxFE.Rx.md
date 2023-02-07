

<!-- <div class="sysobj_h1">adi.QuadMxFE.Rx</div> -->

<!-- <div class="sysobj_top_desc">
Receive data from Analog Devices AD9361 transceiver
</div> -->

<!-- <div class="sysobj_desc_title">Description</div> -->

<div class="sysobj_desc_txt">
<span>
    The adi.QuadMxFE.Rx System object is a signal source that can receive<br>    complex data from the QuadMxFE.<br> <br>    rx = adi.QuadMxFE.Rx;<br>    rx = adi.QuadMxFE.Rx('uri','ip:ip:192.168.2.1');<br> <br>    <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/AD9081.pdf">AD9081 Datasheet</a><br>
</span>

</div>

<div class="sysobj_desc_title">Creation</div>

The class can be instantiated in the following way with and without property name value pairs.

```matlab
dev = adi.QuadMxFE.Rx
dev = adi.QuadMxFE.Rx(Name, Value)
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
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipB')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipB">ChannelNCOFrequenciesChipB <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipB">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipC')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipC">ChannelNCOFrequenciesChipC <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipC">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOFrequenciesChipD')" class="collapsible-property collapsible-property-ChannelNCOFrequenciesChipD">ChannelNCOFrequenciesChipD <span style="text-align:right" class="plus-ChannelNCOFrequenciesChipD">+</span></button>
  <div class="content content-ChannelNCOFrequenciesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipA')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipA">MainNCOFrequenciesChipA <span style="text-align:right" class="plus-MainNCOFrequenciesChipA">+</span></button>
  <div class="content content-MainNCOFrequenciesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipB')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipB">MainNCOFrequenciesChipB <span style="text-align:right" class="plus-MainNCOFrequenciesChipB">+</span></button>
  <div class="content content-MainNCOFrequenciesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipC')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipC">MainNCOFrequenciesChipC <span style="text-align:right" class="plus-MainNCOFrequenciesChipC">+</span></button>
  <div class="content content-MainNCOFrequenciesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOFrequenciesChipD')" class="collapsible-property collapsible-property-MainNCOFrequenciesChipD">MainNCOFrequenciesChipD <span style="text-align:right" class="plus-MainNCOFrequenciesChipD">+</span></button>
  <div class="content content-MainNCOFrequenciesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipA')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipA">ChannelNCOPhasesChipA <span style="text-align:right" class="plus-ChannelNCOPhasesChipA">+</span></button>
  <div class="content content-ChannelNCOPhasesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipB')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipB">ChannelNCOPhasesChipB <span style="text-align:right" class="plus-ChannelNCOPhasesChipB">+</span></button>
  <div class="content content-ChannelNCOPhasesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipC')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipC">ChannelNCOPhasesChipC <span style="text-align:right" class="plus-ChannelNCOPhasesChipC">+</span></button>
  <div class="content content-ChannelNCOPhasesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ChannelNCOPhasesChipD')" class="collapsible-property collapsible-property-ChannelNCOPhasesChipD">ChannelNCOPhasesChipD <span style="text-align:right" class="plus-ChannelNCOPhasesChipD">+</span></button>
  <div class="content content-ChannelNCOPhasesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipA')" class="collapsible-property collapsible-property-MainNCOPhasesChipA">MainNCOPhasesChipA <span style="text-align:right" class="plus-MainNCOPhasesChipA">+</span></button>
  <div class="content content-MainNCOPhasesChipA" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipB')" class="collapsible-property collapsible-property-MainNCOPhasesChipB">MainNCOPhasesChipB <span style="text-align:right" class="plus-MainNCOPhasesChipB">+</span></button>
  <div class="content content-MainNCOPhasesChipB" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipC')" class="collapsible-property collapsible-property-MainNCOPhasesChipC">MainNCOPhasesChipC <span style="text-align:right" class="plus-MainNCOPhasesChipC">+</span></button>
  <div class="content content-MainNCOPhasesChipC" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('MainNCOPhasesChipD')" class="collapsible-property collapsible-property-MainNCOPhasesChipD">MainNCOPhasesChipD <span style="text-align:right" class="plus-MainNCOPhasesChipD">+</span></button>
  <div class="content content-MainNCOPhasesChipD" style="display: none;">
    <p style="padding: 0px;">Frequency of NCO in fine decimators in receive path. Property must be a [1,N] vector where each value is the frequency of an NCO in hertz, and N is the number of channels available.</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('TestModeChipA')" class="collapsible-property collapsible-property-TestModeChipA">TestModeChipA <span style="text-align:right" class="plus-TestModeChipA">+</span></button>
  <div class="content content-TestModeChipA" style="display: none;">
    <p style="padding: 0px;">Test mode of receive path. Options are: 'off' 'midscale_short' 'pos_fullscale' 'neg_fullscale' 'checkerboard' 'pn9' 'pn32' 'one_zero_toggle' 'user' 'pn7' 'pn15' 'pn31' 'ramp'</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('TestModeChipB')" class="collapsible-property collapsible-property-TestModeChipB">TestModeChipB <span style="text-align:right" class="plus-TestModeChipB">+</span></button>
  <div class="content content-TestModeChipB" style="display: none;">
    <p style="padding: 0px;">Test mode of receive path. Options are: 'off' 'midscale_short' 'pos_fullscale' 'neg_fullscale' 'checkerboard' 'pn9' 'pn32' 'one_zero_toggle' 'user' 'pn7' 'pn15' 'pn31' 'ramp'</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('TestModeChipC')" class="collapsible-property collapsible-property-TestModeChipC">TestModeChipC <span style="text-align:right" class="plus-TestModeChipC">+</span></button>
  <div class="content content-TestModeChipC" style="display: none;">
    <p style="padding: 0px;">Test mode of receive path. Options are: 'off' 'midscale_short' 'pos_fullscale' 'neg_fullscale' 'checkerboard' 'pn9' 'pn32' 'one_zero_toggle' 'user' 'pn7' 'pn15' 'pn31' 'ramp'</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('TestModeChipD')" class="collapsible-property collapsible-property-TestModeChipD">TestModeChipD <span style="text-align:right" class="plus-TestModeChipD">+</span></button>
  <div class="content content-TestModeChipD" style="display: none;">
    <p style="padding: 0px;">Test mode of receive path. Options are: 'off' 'midscale_short' 'pos_fullscale' 'neg_fullscale' 'checkerboard' 'pn9' 'pn32' 'one_zero_toggle' 'user' 'pn7' 'pn15' 'pn31' 'ramp'</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnablePFIRsChipA')" class="collapsible-property collapsible-property-EnablePFIRsChipA">EnablePFIRsChipA <span style="text-align:right" class="plus-EnablePFIRsChipA">+</span></button>
  <div class="content content-EnablePFIRsChipA" style="display: none;">
    <p style="padding: 0px;">Enable use of PFIR/PFILT filters for Chip A</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnablePFIRsChipB')" class="collapsible-property collapsible-property-EnablePFIRsChipB">EnablePFIRsChipB <span style="text-align:right" class="plus-EnablePFIRsChipB">+</span></button>
  <div class="content content-EnablePFIRsChipB" style="display: none;">
    <p style="padding: 0px;">Enable use of PFIR/PFILT filters for Chip B</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnablePFIRsChipC')" class="collapsible-property collapsible-property-EnablePFIRsChipC">EnablePFIRsChipC <span style="text-align:right" class="plus-EnablePFIRsChipC">+</span></button>
  <div class="content content-EnablePFIRsChipC" style="display: none;">
    <p style="padding: 0px;">Enable use of PFIR/PFILT filters for Chip C</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('EnablePFIRsChipD')" class="collapsible-property collapsible-property-EnablePFIRsChipD">EnablePFIRsChipD <span style="text-align:right" class="plus-EnablePFIRsChipD">+</span></button>
  <div class="content content-EnablePFIRsChipD" style="display: none;">
    <p style="padding: 0px;">Enable use of PFIR/PFILT filters for Chip D</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('PFIRFilenamesChipA')" class="collapsible-property collapsible-property-PFIRFilenamesChipA">PFIRFilenamesChipA <span style="text-align:right" class="plus-PFIRFilenamesChipA">+</span></button>
  <div class="content content-PFIRFilenamesChipA" style="display: none;">
    <p style="padding: 0px;">Path(s) to FPIR/PFILT filter file(s). Input can be a string or cell array of strings. Files are loading in order for Chip A</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('PFIRFilenamesChipB')" class="collapsible-property collapsible-property-PFIRFilenamesChipB">PFIRFilenamesChipB <span style="text-align:right" class="plus-PFIRFilenamesChipB">+</span></button>
  <div class="content content-PFIRFilenamesChipB" style="display: none;">
    <p style="padding: 0px;">Path(s) to FPIR/PFILT filter file(s). Input can be a string or cell array of strings. Files are loading in order for Chip B</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('PFIRFilenamesChipC')" class="collapsible-property collapsible-property-PFIRFilenamesChipC">PFIRFilenamesChipC <span style="text-align:right" class="plus-PFIRFilenamesChipC">+</span></button>
  <div class="content content-PFIRFilenamesChipC" style="display: none;">
    <p style="padding: 0px;">Path(s) to FPIR/PFILT filter file(s). Input can be a string or cell array of strings. Files are loading in order for Chip C</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('PFIRFilenamesChipD')" class="collapsible-property collapsible-property-PFIRFilenamesChipD">PFIRFilenamesChipD <span style="text-align:right" class="plus-PFIRFilenamesChipD">+</span></button>
  <div class="content content-PFIRFilenamesChipD" style="display: none;">
    <p style="padding: 0px;">Path(s) to FPIR/PFILT filter file(s). Input can be a string or cell array of strings. Files are loading in order for Chip D</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('ExternalAttenuation')" class="collapsible-property collapsible-property-ExternalAttenuation">ExternalAttenuation <span style="text-align:right" class="plus-ExternalAttenuation">+</span></button>
  <div class="content content-ExternalAttenuation" style="display: none;">
    <p style="padding: 0px;">Attenuation value of external HMC425a</p>
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
    <p style="padding: 0px;">Hostname or IP address of remote libIIO deviceHelp for adi.QuadMxFE.Rx/uri is inherited from superclass matlabshared.libiio.base</p>
  </div>
  </div>

<div class="sysobj_desc_title">Example Usage</div>

```

%% Rx set up
rx = adi.QuadMxFE.Rx('uri','ip:analog.local');
rx.SamplesPerFrame = 2^14;
rx.EnabledChannels = 1;

%% Run
for k=1:10
    valid = false;
    while ~valid
        [out, valid] = rx();
    end
end

%% Cleanup
release(rx)

```