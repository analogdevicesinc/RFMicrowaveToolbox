

<!-- <div class="sysobj_h1">adi.DualAD9213.Rx</div> -->

<!-- <div class="sysobj_top_desc">
Receive data from Analog Devices AD9361 transceiver
</div> -->

<!-- <div class="sysobj_desc_title">Description</div> -->

<div class="sysobj_desc_txt">
<span>
    The adi.DualAD9213.Rx System object is a signal source that can receive<br>    complex data from the DualAD9213.<br> <br>    rx = adi.DualAD9213.Rx;<br>    rx = adi.DualAD9213.Rx('uri','ip:ip:192.168.2.1');<br> <br>    <a href="http://www.analog.com/media/en/technical-documentation/data-sheets/AD9213.pdf">AD9213 Datasheet</a><br> <br>
</span>

</div>

<div class="sysobj_desc_title">Creation</div>

The class can be instantiated in the following way with and without property name value pairs.

```matlab
dev = adi.DualAD9213.Rx
dev = adi.DualAD9213.Rx(Name, Value)
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
  <button type="button" onclick="collapse('EnabledChannels')" class="collapsible-property collapsible-property-EnabledChannels">EnabledChannels <span style="text-align:right" class="plus-EnabledChannels">+</span></button>
  <div class="content content-EnabledChannels" style="display: none;">
    <p style="padding: 0px;">Indexs of channels to be enabled. Input should be a [1xN] vector with the indexes of channels to be enabled. Order is irrelevant</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('uri')" class="collapsible-property collapsible-property-uri">uri <span style="text-align:right" class="plus-uri">+</span></button>
  <div class="content content-uri" style="display: none;">
    <p style="padding: 0px;">Hostname or IP address of remote libIIO deviceHelp for adi.DualAD9213.Rx/uri is inherited from superclass matlabshared.libiio.base</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('SamplesPerFrame')" class="collapsible-property collapsible-property-SamplesPerFrame">SamplesPerFrame <span style="text-align:right" class="plus-SamplesPerFrame">+</span></button>
  <div class="content content-SamplesPerFrame" style="display: none;">
    <p style="padding: 0px;">Number of samples per frame, specified as an even positive integer from 2 to 16,777,216. Using values less than 3660 can yield poor performance.Help for adi.DualAD9213.Rx/SamplesPerFrame is inherited from superclass adi.AD9213.Base</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('kernelBuffersCount')" class="collapsible-property collapsible-property-kernelBuffersCount">kernelBuffersCount <span style="text-align:right" class="plus-kernelBuffersCount">+</span></button>
  <div class="content content-kernelBuffersCount" style="display: none;">
    <p style="padding: 0px;">The number of buffers allocated in the kernel for data transfersHelp for adi.DualAD9213.Rx/kernelBuffersCount is inherited from superclass matlabshared.libiio.base</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('dataTypeStr')" class="collapsible-property collapsible-property-dataTypeStr">dataTypeStr <span style="text-align:right" class="plus-dataTypeStr">+</span></button>
  <div class="content content-dataTypeStr" style="display: none;">
    <p style="padding: 0px;">A String Representing the data typeHelp for adi.DualAD9213.Rx/dataTypeStr is inherited from superclass matlabshared.libiio.base</p>
  </div>
  </div>
<div class="property">
  <button type="button" onclick="collapse('SamplesPerFrame')" class="collapsible-property collapsible-property-SamplesPerFrame">SamplesPerFrame <span style="text-align:right" class="plus-SamplesPerFrame">+</span></button>
  <div class="content content-SamplesPerFrame" style="display: none;">
    <p style="padding: 0px;">Number of samples per frame, specified as an even positive integer from 2 to 16,777,216. Using values less than 3660 can yield poor performance.Help for adi.DualAD9213.Rx/SamplesPerFrame is inherited from superclass adi.AD9213.Base</p>
  </div>
  </div>

<div class="sysobj_desc_title">Example Usage</div>

```

%% Rx set up
rx = adi.DualAD9213.Rx('uri','ip:analog.local');
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