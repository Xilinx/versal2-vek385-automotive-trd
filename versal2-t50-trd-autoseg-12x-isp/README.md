## License

#Copyright (C) 2026 Advanced Micro Devices, Inc.
#SPDX-License-Identifier: MIT


## Multi-Camera Automotive 12×-ISP Hardware Design

The Multi-Camera Automotive 12×-ISP design targets:
- **12× MIPI capture (8× 3MP IMX623, 2× 8MP IMX728, 2× 5MP OX05B1S RGB+IR) → ISP processing → DDR → Video Mixer → HDMI-2.1 Tx display pipeline** at **8Kp30**
- **5× MIPI capture (4× 3MP IMX623, 1× 8MP IMX728) → ISP processing → DDR → Video Mixer → HDMI-2.1 Tx display pipeline** at **4Kp30**

The hardware design is targeted for the **VEK385 Rev-B1 & B2 board**.

### Tools Version

- **Vivado™ 2026.1**

### Build Instructions

To build the hardware design and sdt generation:

1. Navigate to the `\versal2-t50-trd-autoseg-12x-isp\hw` folder.
2. Run the following command:
   ```bash
   make all

3. The output XSA file will be available in `\versal2-t50-trd-autoseg-12x-isp\hw\runs\Versal2_T50_12Sensor_ISP\`



## Build Instructions to build software components 

To build the software artifats:

1. Navigate to the `\versal2-t50-trd-autoseg-12x-isp\sw` folder.
2. Run the following command:
   ```bash
   make artifacts
   ```
3. The output boot images will be available in `\versal2-t50-trd-autoseg-12x-isp\sw\artifacts`
