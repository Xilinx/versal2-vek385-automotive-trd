# # Copyright (c) 2026 Advanced Micro Devices, Inc.
# # SPDX-License-Identifier: MIT
# # -----------------------------------------------*/

#!/bin/bash

# detect whether this script is sourced (needed so error aborts don't close the caller's shell)
(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

# Ctrl+C support: stop gst pipelines one at a time, most-recently-launched first (LIFO).
# After all pipelines are stopped, source this script again and re-run "start_pipelines"
# to relaunch them one by one without repeating the overlay/sensor setup.
PIPELINE_PIDS=()
PIPELINE_NAMES=()

stop_one_pipeline() {
    if [ ${#PIPELINE_PIDS[@]} -eq 0 ]; then
        return
    fi
    local last=$(( ${#PIPELINE_PIDS[@]} - 1 ))
    local pid=${PIPELINE_PIDS[$last]}
    local name=${PIPELINE_NAMES[$last]}
    echo ""
    echo "Stopping pipeline: $name (pid $pid)..."
    # gst-launch only handles SIGINT specially (graceful EOS-based shutdown
    # that cleanly stops the v4l2 capture stream); a plain SIGTERM kills it
    # abruptly and can leave the ISP subdev's internal pipeline/calibration
    # state dirty, causing the next start_pipelines to fail to reload calib
    # on that port.
    kill -INT "$pid" 2>/dev/null
    # Poll for exit with a bounded timeout: an EOS-based shutdown can still
    # occasionally hang (e.g. stuck tearing down a kmssink DRM plane).
    # Without a timeout here, wait would block forever and no further
    # Ctrl+C could ever reach the remaining pipelines.
    for i in 1 2 3 4 5; do
        kill -0 "$pid" 2>/dev/null || break
        sleep 1
    done
    if kill -0 "$pid" 2>/dev/null; then
        echo "Pipeline $name (pid $pid) did not exit in time, sending SIGKILL..."
        kill -9 "$pid" 2>/dev/null
    fi
    wait "$pid" 2>/dev/null
    unset 'PIPELINE_PIDS[last]'
    unset 'PIPELINE_NAMES[last]'
    PIPELINE_PIDS=("${PIPELINE_PIDS[@]}")
    PIPELINE_NAMES=("${PIPELINE_NAMES[@]}")
    if [ ${#PIPELINE_PIDS[@]} -eq 0 ]; then
        echo "All pipelines stopped. Run 'start_pipelines' to relaunch them one by one."
    else
        echo "${#PIPELINE_PIDS[@]} pipeline(s) still running. Press Ctrl+C to stop the next one."
    fi
    # Re-arm explicitly: some shells reset a trap to its default action once
    # it fires, so without this a 2nd Ctrl+C would do nothing after the 1st.
    trap stop_one_pipeline INT TERM
}
trap stop_one_pipeline INT TERM

echo "Step 1: Unpacking 12xisp_overlay.zip to /lib/firmware/xilinx..."
unzip -o 12xisp_overlay.zip
cp -rf 12xisp_overlay /lib/firmware/xilinx

echo "Step 2: Loading PL overlay 12xisp_overlay via dfx-mgr-client..."
dfx-mgr-client -loadByName 12xisp_overlay
sleep 5
echo "Checking kernel logs (dmesg)..."
dmesg -n 8
sleep 5

# --- Verify all video nodes were created by the PL overlay before continuing ---
echo "Step 3: Verifying video nodes /dev/video0 to /dev/video27 were created by the PL overlay..."
FIRST_VIDEO_NODE=0
LAST_VIDEO_NODE=27
RETRY_DELAY=2

check_video_nodes() {
    missing=()
    for i in $(seq $FIRST_VIDEO_NODE $LAST_VIDEO_NODE); do
        if [ ! -e "/dev/video${i}" ]; then
            missing+=("/dev/video${i}")
        fi
    done
}

check_video_nodes

if [ ${#missing[@]} -ne 0 ]; then
    echo "Attempt 1: ${#missing[@]} node(s) missing: ${missing[*]}. Retrying once..."
    sleep $RETRY_DELAY
    check_video_nodes
fi

if [ ${#missing[@]} -eq 0 ]; then
    present=()
    for i in $(seq $FIRST_VIDEO_NODE $LAST_VIDEO_NODE); do
        present+=("/dev/video${i}")
    done
    echo "all video nodes are present"
    echo "Video nodes present: ${present[*]}"
else
    echo "ERROR: PL overlay did not create all expected video nodes after retry. Missing: ${missing[*]}"
    if [ "$SOURCED" -eq 1 ]; then return 1; else exit 1; fi
fi
# --- End video node verification ---

# HDMI modetest
echo "Step 4: Setting HDMI output mode to 7680x4320@30 on b0040000.v_mix..."
modetest -D b0040000.v_mix
sleep 3
modetest -D b0040000.v_mix -s 68:7680x4320-30@BG24&

sleep 5

echo "Step 5: Configuring 12 sensors (IMX623 x8, IMX728 x2, OX05B1S x2) across isp_subdev0-5..."
echo 0 hw_mcm=1 sensor=imx623 sensor_id=0 vc_id=0 > /proc/vsi/isp_subdev0
echo 1 hw_mcm=1 sensor=imx623 sensor_id=1 vc_id=1 > /proc/vsi/isp_subdev0
echo 2 hw_mcm=1 sensor=imx623  sensor_id=2 vc_id=0 > /proc/vsi/isp_subdev0
echo 3 hw_mcm=1 sensor=imx623  sensor_id=3 vc_id=1 > /proc/vsi/isp_subdev0
echo 0 hw_mcm=1 sensor=imx623 sensor_id=4 vc_id=0 > /proc/vsi/isp_subdev2
echo 1 hw_mcm=1 sensor=imx623 sensor_id=5 vc_id=1 > /proc/vsi/isp_subdev2
echo 2 hw_mcm=1 sensor=imx623  sensor_id=6 vc_id=0 > /proc/vsi/isp_subdev2
echo 3 hw_mcm=1 sensor=imx623  sensor_id=7 vc_id=1 > /proc/vsi/isp_subdev2

echo 0 sensor=imx728 sensor_id=8 vc_id=0 > /proc/vsi/isp_subdev1
echo 0 sensor=imx728 sensor_id=9 vc_id=1 > /proc/vsi/isp_subdev3
echo 0 hw_mcm=1 mode=1 sensor=ox05b1s sensor_id=10 > /proc/vsi/isp_subdev4
echo 1 hw_mcm=1 mode=2 sensor=ox05b1s sensor_id=10 > /proc/vsi/isp_subdev4
echo 0 vc_id=2 hw_mcm=1 mode=1 sensor=ox05b1s sensor_id=11 > /proc/vsi/isp_subdev5
echo 1 vc_id=3 hw_mcm=1 mode=2 sensor=ox05b1s sensor_id=11 > /proc/vsi/isp_subdev5

sleep 3

echo "Step 6: Loading calibration/tuning JSON files for each sensor..."

echo 0 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 0 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 0 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json  > /proc/vsi/isp_subdev0

sleep 1
echo 1 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json> /proc/vsi/isp_subdev0
echo 1 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 1 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json  > /proc/vsi/isp_subdev0

sleep 1
echo 2 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 2 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 2 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json  > /proc/vsi/isp_subdev0

sleep 1

echo 3 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 3 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev0
echo 3 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json  > /proc/vsi/isp_subdev0
sleep 1

echo 0 calib=/usr/share/Tuning_files/IMX728/IMX728_v1.1.json > /proc/vsi/isp_subdev1
echo 0 auto_json=/usr/share/Tuning_files/IMX728/auto_IMX728_v1.1.json > /proc/vsi/isp_subdev1
echo 0 manu_json=/usr/share/Tuning_files/IMX728/manual_IMX728_v1.1.json > /proc/vsi/isp_subdev1
sleep 1

echo 0 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 0 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 0 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
sleep 1

echo 1 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 1 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 1 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
sleep 1

echo 2 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 2 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 2 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json  > /proc/vsi/isp_subdev2
sleep 1

echo 3 calib=/usr/share/Tuning_files/IMX623/1920/IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 3 auto_json=/usr/share/Tuning_files/IMX623/1920/auto_IMX623_1920_v1.0.json > /proc/vsi/isp_subdev2
echo 3 manu_json=/usr/share/Tuning_files/IMX623/1920/manual_IMX623_1920_v1.0.json  > /proc/vsi/isp_subdev2
sleep 1

echo 0 calib=/usr/share/Tuning_files/IMX728/IMX728_v1.1.json > /proc/vsi/isp_subdev3
echo 0 auto_json=/usr/share/Tuning_files/IMX728/auto_IMX728_v1.1.json > /proc/vsi/isp_subdev3
echo 0 manu_json=/usr/share/Tuning_files/IMX728/manual_IMX728_v1.1.json > /proc/vsi/isp_subdev3
sleep 1

echo 0 calib=/usr/share/Tuning_files/OX05B1S/OX05B1S_v1.0.json  > /proc/vsi/isp_subdev4
echo 0 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_v1.0.json >  /proc/vsi/isp_subdev4
echo 0 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_v1.0.json  > /proc/vsi/isp_subdev4
sleep 1

echo 1 calib=/usr/share/Tuning_files/OX05B1S/OX05B1S_v1.0.json > /proc/vsi/isp_subdev4
echo 1 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_bmode_v1.0.json > /proc/vsi/isp_subdev4
echo 1 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_bmode_v1.0.json  > /proc/vsi/isp_subdev4

sleep 1
echo 0 calib=/usr/share/Tuning_files/OX05B1S/OX05B1S_v1.0.json  > /proc/vsi/isp_subdev5
echo 0 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_v1.0.json >  /proc/vsi/isp_subdev5
echo 0 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_v1.0.json  > /proc/vsi/isp_subdev5
sleep 1
echo 1 calib=/usr/share/Tuning_files/OX05B1S/OX05B1S_v1.0.json > /proc/vsi/isp_subdev5
echo 1 auto_json=/usr/share/Tuning_files/OX05B1S/auto_OX05B1S_bmode_v1.0.json > /proc/vsi/isp_subdev5
echo 1 manu_json=/usr/share/Tuning_files/OX05B1S/manual_OX05B1S_bmode_v1.0.json  > /proc/vsi/isp_subdev5

sleep 1
echo "Step 7: Enable New FMC Support"
echo 1 > /sys/module/visp/parameters/fmc_id

sleep 2
echo "Step 8: Starting isp_media_server..."
isp_media_server&
sleep 10

# start_pipelines: launches all 14 gst pipelines, tracking each PID/name in launch order so
# stop_one_pipeline() can tear them down LIFO on Ctrl+C. Call this function again (after
# sourcing) to relaunch pipelines one by one without repeating Steps 1-7.
start_pipelines() {
    PIPELINE_PIDS=()
    PIPELINE_NAMES=()

    echo "Step 9: Launching 6 8MP gst pipelines (kmssink plane-id 52,54,56,60,58,62)..."
    gst-launch-1.0  -v v4l2src device=/dev/video8  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=24/1" ! queue ! perf name=ISP1_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=52 render-rectangle="<0, 0, 3840, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP1_MP_port0")

    sleep 40
    gst-launch-1.0  -v v4l2src device=/dev/video18  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=24/1" ! queue ! perf name=ISP3_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=54 render-rectangle="<3840, 0, 3840, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP3_MP_port0")
    sleep 25

    gst-launch-1.0  -v v4l2src device=/dev/video20  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP4_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=56 render-rectangle="<0, 3240, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP4_MP_port0")
    sleep 30
    gst-launch-1.0  -v v4l2src device=/dev/video22  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=GRAY8, framerate=30/1" ! queue ! perf name=ISP4_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=60 render-rectangle="<1920, 3240, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP4_MP_port1")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video24  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP5_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=58 render-rectangle="<3840, 3240, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP5_MP_port0")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video26  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=GRAY8, framerate=30/1" ! queue ! perf name=ISP5_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=62 render-rectangle="<5760, 3240, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP5_MP_port1")
    sleep 25

    echo "Step 10: Launching 8 3MP gst pipelines (kmssink plane-id 36,38,40,42,44,46,48,50)..."

    gst-launch-1.0  -v v4l2src device=/dev/video0  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=36 render-rectangle="<0, 1080, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP0_MP_port0")
    sleep 30
    gst-launch-1.0  -v v4l2src device=/dev/video2  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=38 render-rectangle="<1920, 1080, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP0_MP_port1")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video4  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP0_MP_port2 !  kmssink bus-id=b0040000.v_mix  plane-id=40 render-rectangle="<3840, 1080, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP0_MP_port2")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video6  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port3 !  kmssink bus-id=b0040000.v_mix  plane-id=42 render-rectangle="<5760, 1080, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP0_MP_port3")
    sleep 25

    gst-launch-1.0  -v v4l2src device=/dev/video10  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP2_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=44 render-rectangle="<0, 2160, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP2_MP_port0")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video12  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP2_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=46 render-rectangle="<1920, 2160, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP2_MP_port1")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video14  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue !  perf name=ISP2_MP_port2 !  kmssink bus-id=b0040000.v_mix  plane-id=48 render-rectangle="<3840, 2160, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP2_MP_port2")
    sleep 25
    gst-launch-1.0  -v v4l2src device=/dev/video16  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP2_MP_port3 !  kmssink bus-id=b0040000.v_mix  plane-id=50 render-rectangle="<5760, 2160, 1920, 1080>" &
    PIPELINE_PIDS+=($!); PIPELINE_NAMES+=("ISP2_MP_port3")

    echo "All 14 pipelines launched."

    echo "Press Ctrl+C to stop pipelines one by one (most recently launched first)."
    echo "After all are stopped, run 'start_pipelines' again to relaunch them one by one."
    while [ ${#PIPELINE_PIDS[@]} -gt 0 ]; do
        sleep 1
    done
}

start_pipelines
