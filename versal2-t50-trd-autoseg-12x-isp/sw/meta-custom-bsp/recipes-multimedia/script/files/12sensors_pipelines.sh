# Copyright (c) 2026 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: MIT
# -----------------------------------------------

#!/bin/bash

# Step 1: TFTP file transfer


# Step 2: Move kernel module
mv /lib/modules/6.12.40-xilinx-g31626ef92ff1/updates/visp_mbox/visp_mbox.ko /usr/share/
mv /lib/modules/6.12.40-xilinx-g31626ef92ff1/updates/visp/visp.ko  /usr/share/
mv /lib/modules/6.12.40-xilinx-g31626ef92ff1/updates/visp_video/visp_video.ko  /usr/share/

sleep 1

unzip  pl_overlay.zip
cp -rf  pl_overlay /lib/firmware/xilinx
dfx-mgr-client -load pl_overlay

sleep 5
# Step 3: Load RPU firmware

echo isp-r52-6-firmware.elf  > /sys/class/remoteproc/remoteproc1/firmware
echo start > /sys/class/remoteproc/remoteproc1/state
sleep 2
echo isp-r52-7-firmware.elf  > /sys/class/remoteproc/remoteproc2/firmware
echo start > /sys/class/remoteproc/remoteproc2/state
sleep 2
echo isp-r52-8-firmware.elf  > /sys/class/remoteproc/remoteproc3/firmware
echo start > /sys/class/remoteproc/remoteproc3/state
sleep 2

# Step 5: Insert kernel module
insmod /usr/share/visp_mbox.ko
insmod /usr/share/visp.ko
insmod /usr/share/visp_video.ko

sleep 2

dmesg -n 8
modetest -D b0070000.v_mix
sleep 3
# HDMI modetest 

modetest -D b0070000.v_mix -s 67:7680x4320-30@BG24&

sleep 5
# Step 6: Configure sensor
echo 0 hw_mcm=1 sensor=imx623 sensor_id=0 > /proc/vsi/isp_subdev0
echo 1 hw_mcm=1 sensor=imx623 sensor_id=1 > /proc/vsi/isp_subdev0
echo 2 hw_mcm=1 sensor=imx623  sensor_id=2 > /proc/vsi/isp_subdev0
echo 3 hw_mcm=1 sensor=imx623  sensor_id=3 > /proc/vsi/isp_subdev0
echo 0 hw_mcm=1 sensor=imx623 sensor_id=4 > /proc/vsi/isp_subdev2
echo 1 hw_mcm=1 sensor=imx623 sensor_id=5 > /proc/vsi/isp_subdev2
echo 2 hw_mcm=1 sensor=imx623  sensor_id=6 > /proc/vsi/isp_subdev2
echo 3 hw_mcm=1 sensor=imx623  sensor_id=7 > /proc/vsi/isp_subdev2
echo 0 sensor=imx728 sensor_id=8 > /proc/vsi/isp_subdev1
echo 0 vc_id=1 sensor=imx728 sensor_id=9 > /proc/vsi/isp_subdev3
echo 0 hw_mcm=1 mode=1 sensor=ox05b1s sensor_id=10 > /proc/vsi/isp_subdev4
echo 1 hw_mcm=1 mode=2 sensor=ox05b1s sensor_id=10 > /proc/vsi/isp_subdev4
echo 0 vc_id=2 hw_mcm=1 mode=1 sensor=ox05b1s sensor_id=11 > /proc/vsi/isp_subdev5
echo 1 vc_id=3 hw_mcm=1 mode=2 sensor=ox05b1s sensor_id=11 > /proc/vsi/isp_subdev5

sleep 3

echo 0 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev0
echo 0 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0
echo 0 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0

echo 1 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev0
echo 1 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0
echo 1 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0

echo 2 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev0
echo 2 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0
echo 2 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0

echo 3 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev0
echo 3 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0
echo 3 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev0

echo 0 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev2
echo 0 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2
echo 0 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2

echo 1 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev2
echo 1 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2
echo 1 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2

echo 2 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev2
echo 2 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2
echo 2 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2

echo 3 xml=/usr/share/Tuning_files/IMX623/IMX623_ewd_2026_M15.xml  > /proc/vsi/isp_subdev2
echo 3 auto_json=/usr/share/Tuning_files/IMX623/auto_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2
echo 3 manu_json=/usr/share/Tuning_files/IMX623/manual_IMX623_ewd_2026_M15.json  > /proc/vsi/isp_subdev2

echo 0 xml=/usr/share/Tuning_files/IMX728/IMX728_ewd_2026_M15.xml  > /proc/vsi/isp_subdev3
echo 0 auto_json=/usr/share/Tuning_files/IMX728/auto_IMX728_ewd_2026_M15.json  > /proc/vsi/isp_subdev3
echo 0 manu_json=/usr/share/Tuning_files/IMX728/manual_IMX728_ewd_2026_M15.json  > /proc/vsi/isp_subdev3

echo 0 xml=/usr/share/Tuning_files/IMX728/IMX728_ewd_2026_M15.xml  > /proc/vsi/isp_subdev1
echo 0 auto_json=/usr/share/Tuning_files/IMX728/auto_IMX728_ewd_2026_M15.json  > /proc/vsi/isp_subdev1
echo 0 manu_json=/usr/share/Tuning_files/IMX728/manual_IMX728_ewd_2026_M15.json  > /proc/vsi/isp_subdev1

sleep 2 

echo 0 xml=/usr/share/Tuning_files/OX05B1S/OX05B1S_ewd_2026_M15.xml  > /proc/vsi/isp_subdev4
echo 0 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_ewd_2026_M15.json  > /proc/vsi/isp_subdev4
echo 0 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_ewd_2026_M15.json  > /proc/vsi/isp_subdev4

echo 1 xml=/usr/share/Tuning_files/OX05B1S/OX05B1S_ewd_2026_M15.xml  > /proc/vsi/isp_subdev4
echo 1 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_bmode_ewd_2026_M15.json  > /proc/vsi/isp_subdev4
echo 1 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_bmode_ewd_2026_M15.json  > /proc/vsi/isp_subdev4

echo 0 xml=/usr/share/Tuning_files/OX05B1S/OX05B1S_ewd_2026_M15.xml  > /proc/vsi/isp_subdev5
echo 0 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_ewd_2026_M15.json  > /proc/vsi/isp_subdev5
echo 0 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_ewd_2026_M15.json  > /proc/vsi/isp_subdev5

echo 1 xml=/usr/share/Tuning_files/OX05B1S/OX05B1S_ewd_2026_M15.xml  > /proc/vsi/isp_subdev5
echo 1 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_bmode_ewd_2026_M15.json  > /proc/vsi/isp_subdev5
echo 1 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_bmode_ewd_2026_M15.json  > /proc/vsi/isp_subdev5

isp_media_server&
sleep 2

echo "launching 8MP pipelines"
gst-launch-1.0  -v v4l2src device=/dev/video8  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=24/1" ! queue ! perf name=ISP1_MP_port0 !  kmssink bus-id=b0070000.v_mix  plane-id=51 render-rectangle="<0, 0, 3840, 1080>" &

sleep 60
gst-launch-1.0  -v v4l2src device=/dev/video18  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=24/1" ! queue ! perf name=ISP3_MP_port0 !  kmssink bus-id=b0070000.v_mix  plane-id=53 render-rectangle="<3840, 0, 3840, 1080>" &
sleep 30

echo "launching 5MP pipelines"
gst-launch-1.0  -v v4l2src device=/dev/video20  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP4_MP_port0 !  kmssink bus-id=b0070000.v_mix  plane-id=55 render-rectangle="<0, 3240, 1920, 1080>" &
sleep 20
gst-launch-1.0  -v v4l2src device=/dev/video22  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=GRAY8, framerate=30/1" ! queue ! perf name=ISP4_MP_port1 !  kmssink bus-id=b0070000.v_mix  plane-id=59 render-rectangle="<1920, 3240, 1920, 1080>" &
sleep 20
gst-launch-1.0  -v v4l2src device=/dev/video24  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP5_MP_port0 !  kmssink bus-id=b0070000.v_mix  plane-id=57 render-rectangle="<3840, 3240, 1920, 1080>" &
sleep 20
gst-launch-1.0  -v v4l2src device=/dev/video26  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=GRAY8, framerate=30/1" ! queue ! perf name=ISP5_MP_port1 !  kmssink bus-id=b0070000.v_mix  plane-id=61 render-rectangle="<5760, 3240, 1920, 1080>" &
sleep 20

echo "launching 3MP pipelines"

gst-launch-1.0  -v v4l2src device=/dev/video0  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port0 !  kmssink bus-id=b0070000.v_mix  plane-id=35 render-rectangle="<0, 1080, 1920, 1080>" &
sleep 40
gst-launch-1.0  -v v4l2src device=/dev/video2  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port1 !  kmssink bus-id=b0070000.v_mix  plane-id=37 render-rectangle="<1920, 1080, 1920, 1080>" &
sleep 20
gst-launch-1.0  -v v4l2src device=/dev/video4  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP0_MP_port2 !  kmssink bus-id=b0070000.v_mix  plane-id=39 render-rectangle="<3840, 1080, 1920, 1080>" &
sleep 15
gst-launch-1.0  -v v4l2src device=/dev/video6  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port3 !  kmssink bus-id=b0070000.v_mix  plane-id=41 render-rectangle="<5760, 1080, 1920, 1080>" &
sleep 15
gst-launch-1.0  -v v4l2src device=/dev/video10  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP2_MP_port0 !  kmssink bus-id=b0070000.v_mix  plane-id=43 render-rectangle="<0, 2160, 1920, 1080>" &
sleep 30
gst-launch-1.0  -v v4l2src device=/dev/video12  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP2_MP_port1 !  kmssink bus-id=b0070000.v_mix  plane-id=45 render-rectangle="<1920, 2160, 1920, 1080>" &
sleep 20
gst-launch-1.0  -v v4l2src device=/dev/video14  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP2_MP_port2 !  kmssink bus-id=b0070000.v_mix  plane-id=47 render-rectangle="<3840, 2160, 1920, 1080>" &
sleep 20
gst-launch-1.0  -v v4l2src device=/dev/video16  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP2_MP_port3 !  kmssink bus-id=b0070000.v_mix  plane-id=49 render-rectangle="<5760, 2160, 1920, 1080>" &


