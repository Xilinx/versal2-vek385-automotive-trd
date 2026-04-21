#!/bin/bash
set -e

MODE="${1:-}"
if [[ -z "${MODE}" ]]; then
  echo "Usage: $0 {12x8mp|6x8mp}"
  exit 1
fi

if [[ "${MODE}" != "12x8mp" && "${MODE}" != "6x8mp" ]]; then
  echo "Invalid mode: ${MODE}"
  echo "Usage: $0 {12x8mp|6x8mp}"
  exit 1
fi


# ==========================================================
# Step 1: Move kernel module
# ==========================================================
mv /lib/modules/6.12.40-xilinx-g31626ef92ff1/updates/visp_mbox/visp_mbox.ko /usr/share/ || true
mv /lib/modules/6.12.40-xilinx-g31626ef92ff1/updates/visp/visp.ko  /usr/share/ || true
mv /lib/modules/6.12.40-xilinx-g31626ef92ff1/updates/visp_video/visp_video.ko  /usr/share/ || true

sleep 2
echo "loading overlay"
unzip -o 12x8mp_overlay.zip
cp -rf 12x8mp_overlay /lib/firmware/xilinx
dfx-mgr-client -load 12x8mp_overlay


sleep 3

echo "RPU Firmware loading "
# ==========================================================
# Step 3: Load RPU firmware
# ==========================================================
echo isp-r52-6-firmware.elf > /sys/class/remoteproc/remoteproc1/firmware
echo start > /sys/class/remoteproc/remoteproc1/state
sleep 5

echo isp-r52-7-firmware.elf > /sys/class/remoteproc/remoteproc2/firmware
echo start > /sys/class/remoteproc/remoteproc2/state
sleep 5

echo isp-r52-8-firmware.elf > /sys/class/remoteproc/remoteproc3/firmware
echo start > /sys/class/remoteproc/remoteproc3/state
sleep 5

# ==========================================================
# Step 4: Insert kernel module
# ==========================================================
insmod /usr/share/visp_mbox.ko || true
insmod /usr/share/visp.ko || true
insmod /usr/share/visp_video.ko || true

sleep 3
dmesg -n 8
modetest -D b0040000.v_mix
sleep 3

# ==========================================================
# HDMI modetest (hard-coded; kept commented like your script)
# ==========================================================
modetest -D b0040000.v_mix -s 63:7680x4320-30@BG24&

sleep 5

# ==========================================================
# Sensor routing
# ==========================================================
echo 0 hw_mcm=1 sensor=imx728 sensor_id=0  > /proc/vsi/isp_subdev0
echo 1 hw_mcm=1 sensor=imx728 sensor_id=1  > /proc/vsi/isp_subdev0
echo 0 vc_id=0 hw_mcm=1 sensor=imx728 sensor_id=2  > /proc/vsi/isp_subdev1
echo 1 vc_id=1 hw_mcm=1 sensor=imx728 sensor_id=3  > /proc/vsi/isp_subdev1
echo 0 hw_mcm=1 sensor=imx728 sensor_id=4  > /proc/vsi/isp_subdev2
echo 1 hw_mcm=1 sensor=imx728 sensor_id=5  > /proc/vsi/isp_subdev2
echo 0 vc_id=0 hw_mcm=1 sensor=imx728 sensor_id=6  > /proc/vsi/isp_subdev3
echo 1 vc_id=1 hw_mcm=1 sensor=imx728 sensor_id=7  > /proc/vsi/isp_subdev3
echo 0 hw_mcm=1 sensor=imx728 sensor_id=8  > /proc/vsi/isp_subdev4
echo 1 hw_mcm=1 sensor=imx728 sensor_id=9  > /proc/vsi/isp_subdev4
echo 0 vc_id=0 hw_mcm=1 sensor=imx728 sensor_id=10 > /proc/vsi/isp_subdev5
echo 1 vc_id=1 hw_mcm=1 sensor=imx728 sensor_id=11 > /proc/vsi/isp_subdev5

sleep 4

# ==========================================================
# Load tuning files
# ==========================================================
for sd in 0 1 2 3 4 5; do
  echo 0 xml=/usr/share/Tuning_files/IMX728/IMX728_ewd_2026_M15.xml               > /proc/vsi/isp_subdev${sd}
  echo 0 auto_json=/usr/share/Tuning_files/IMX728/auto_IMX728_ewd_2026_M15.json   > /proc/vsi/isp_subdev${sd}
  echo 0 manu_json=/usr/share/Tuning_files/IMX728/manual_IMX728_ewd_2026_M15.json > /proc/vsi/isp_subdev${sd}

  echo 1 xml=/usr/share/Tuning_files/IMX728/IMX728_ewd_2026_M15.xml               > /proc/vsi/isp_subdev${sd}
  echo 1 auto_json=/usr/share/Tuning_files/IMX728/auto_IMX728_ewd_2026_M15.json   > /proc/vsi/isp_subdev${sd}
  echo 1 manu_json=/usr/share/Tuning_files/IMX728/manual_IMX728_ewd_2026_M15.json > /proc/vsi/isp_subdev${sd}
done

# ==========================================================
# Start media server (everything above always executes)
# ==========================================================
isp_media_server &
sleep 3
# =========================================================
# Pipelines based on MODE ONLY
#   12x8mp : 12 tiles (4x3 grid) @ 1920x1440 each
#   6x8mp  : 6 tiles (3x2 grid) @ 2560x2160 each (input is 3840x2160)
# ==========================================================

if [[ "${MODE}" == "12x8mp" ]]; then
  echo "[INFO] Launching 12x 8MP streams in 4x3 grid on 8K HDMI (tiles 1920x1440)"

  gst-launch-1.0  -v v4l2src device=/dev/video0  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP0_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=35 render-rectangle="<0,0, 1920, 1440>" &
  sleep 40
  gst-launch-1.0  -v v4l2src device=/dev/video2  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP0_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=37 render-rectangle="<1920, 0, 1920, 1440>" &
  sleep 20
  gst-launch-1.0  -v v4l2src device=/dev/video4  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP1_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=39 render-rectangle="<3840, 0, 1920, 1440>" &
  sleep 20
  gst-launch-1.0  -v v4l2src device=/dev/video6  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP1_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=41 render-rectangle="<5760, 0, 1920, 1440>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video8  io-mode=4 ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP2_MP_port0 ! kmssink bus-id=b0040000.v_mix plane-id=43 render-rectangle="<0,1440,1920, 1440>" &
  sleep 30
  gst-launch-1.0 -v v4l2src device=/dev/video10 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP2_MP_port1 ! kmssink bus-id=b0040000.v_mix plane-id=45 render-rectangle="<1920, 1440, 1920, 1440>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video12 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP3_MP_port0 ! kmssink bus-id=b0040000.v_mix plane-id=47 render-rectangle="<3840, 1440, 1920, 1440>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video14 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP3_MP_port1 ! kmssink bus-id=b0040000.v_mix plane-id=49 render-rectangle="<5760, 1440, 1920, 1440>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video16 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP4_MP_port0 ! kmssink bus-id=b0040000.v_mix plane-id=51 render-rectangle="<0, 2880, 1920, 1440>" &
  sleep 40
  gst-launch-1.0 -v v4l2src device=/dev/video18 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP4_MP_port1 ! kmssink bus-id=b0040000.v_mix plane-id=53 render-rectangle="<1920, 2880, 1920, 1440>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video20 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP5_MP_port0 ! kmssink bus-id=b0040000.v_mix plane-id=55 render-rectangle="<3840, 2880, 1920, 1440>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video22 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP5_MP_port1 ! kmssink bus-id=b0040000.v_mix plane-id=57 render-rectangle="<5760, 2880, 1920, 1440>" &

else
  echo "[INFO] Launching 6x 8MP streams on 8K HDMI in 3x2 grid"
  echo "[INFO] Input: 3840x2160  ->  Display tiles: 2560x2160"

  gst-launch-1.0  -v v4l2src device=/dev/video0  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP0_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=35 render-rectangle="<0, 0, 2560, 2160>" &
  sleep 40
  gst-launch-1.0  -v v4l2src device=/dev/video2  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP0_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=37 render-rectangle="<2560, 0, 2560, 2160>" &
  sleep 20
  gst-launch-1.0  -v v4l2src device=/dev/video4  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP1_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=39 render-rectangle="<5120, 0, 2560, 2160>" &
  sleep 20
  gst-launch-1.0  -v v4l2src device=/dev/video6  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP1_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=41 render-rectangle="<0, 2160, 2560, 2160>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video8  io-mode=4 ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=20/1" ! queue ! perf name=ISP2_MP_port0 ! kmssink bus-id=b0040000.v_mix plane-id=43 render-rectangle="<2560, 2160, 2560, 2160>" &
  sleep 20
  gst-launch-1.0 -v v4l2src device=/dev/video10 io-mode=4 ! "video/x-raw, width=3840, height=2160,format=RGB,framerate=20/1" ! queue ! perf name=ISP2_MP_port1 ! kmssink bus-id=b0040000.v_mix plane-id=45 render-rectangle="<5120, 2160, 2560, 2160>" &
  sleep 20
fi

wait
``
