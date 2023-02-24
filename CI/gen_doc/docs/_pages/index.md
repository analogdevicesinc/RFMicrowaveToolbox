{% include 'header.tmpl' %}

<!-- Hide header and click button -->
<style>
  .md-typeset h1,
  .md-content__button {
    display: none;
  }
</style>

<center>
<div class="dark-logo">
<img src="https://raw.githubusercontent.com/analogdevicesinc/RFMicrowaveToolbox/main/CI/doc/rfm_300.png" alt="RFuW Toolbox" width="80%">
</div>
<div class="light-logo">
<img src="https://raw.githubusercontent.com/analogdevicesinc/RFMicrowaveToolbox/main/CI/doc/rfm_w_300.png" alt="RFuW Toolbox" width="80%">
</div>
</center>


ADI maintains a set of tools to model, interface, and target with ADI's beamformers and microwave devices within MATLAB and Simulink. These are combined into single Toolbox which contains a set of Board Support Packages (BSP). The list of supported boards is provided below.

The following have device-specific implementations in MATLAB and Simulink. If a device has an IIO driver, MATLAB support is possible, but a device-specific MATLAB or Simulink interface may not exist yet.

| Evaluation Card | FPGA Board | Streaming Support | Targeting | Variants and Minimum Supported Release |
| --------- | --------- | --------- | --------- | --------- |
| ADALM-PHASER | NA | Yes | No | ADI (2021b) |
| Stingray | ZCU102 | Yes | No | ADI (2021b) |
