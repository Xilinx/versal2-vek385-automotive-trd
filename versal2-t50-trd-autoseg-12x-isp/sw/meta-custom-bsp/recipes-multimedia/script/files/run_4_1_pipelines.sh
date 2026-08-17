# # Copyright (c) 2026 Advanced Micro Devices, Inc.
# # SPDX-License-Identifier: MIT
# # -----------------------------------------------*/

#!/bin/bash

# detect whether this script is sourced (needed so error aborts don't close the caller's shell)
(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

echo "Step 1: Unpacking sony4+1_overlay.zip to /lib/firmware/xilinx..."
unzip -o sony4+1_overlay.zip
cp -rf sony4+1_overlay /lib/firmware/xilinx

echo "Step 2: Loading PL overlay sony4+1_overlay via dfx-mgr-client..."
dfx-mgr-client -loadByName sony4+1_overlay
sleep 5
echo "Checking kernel logs (dmesg)..."
dmesg -n 8
sleep 5

# --- Verify all video nodes were created by the PL overlay before continuing ---
echo "Step 3: Verifying video nodes /dev/video0 to /dev/video9 were created by the PL overlay..."
FIRST_VIDEO_NODE=0
LAST_VIDEO_NODE=9
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

echo "Step 4: Additional status checks (isp subdevices, media nodes, loaded modules, CMA memory)..."
ls -l /proc/vsi/isp*
ls -l /dev/media*
lsmod
cat /proc/meminfo | grep -i cma

echo "Step 5: Configuring 4+1 sensors (IMX623 x4, IMX728 x1) across isp_subdev0-1..."
echo 0 hw_mcm=1 sensor=imx623 sensor_id=0 vc_id=0 > /proc/vsi/isp_subdev0
echo 1 hw_mcm=1 sensor=imx623 sensor_id=1 vc_id=1 > /proc/vsi/isp_subdev0
echo 2 hw_mcm=1 sensor=imx623 sensor_id=2 vc_id=0 > /proc/vsi/isp_subdev0
echo 3 hw_mcm=1 sensor=imx623 sensor_id=3 vc_id=1 > /proc/vsi/isp_subdev0
echo 0 sensor=imx728 sensor_id=8 vc_id=0 > /proc/vsi/isp_subdev1

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

echo "Step 7: Enable New FMC Support"
echo 1 > /sys/module/visp/parameters/fmc_id

sleep 2
echo "Step 8: Starting isp_media_server..."
isp_media_server &
sleep 10

echo "Step 9: Setting HDMI output mode to 3840x2160@30 on b0040000.v_mix..."
modetest -M xlnx
sleep 3
modetest -D b0040000.v_mix -s 68:3840x2160-30@BG24 &

sleep 20

handle_sigint() {
    if [ "$STOP_ALPHA_LOOP" -eq 0 ]; then
        echo ""
        echo "Ctrl+C received: stopping alpha-toggle loop. Press Ctrl+C again to stop pipelines one at a time."
        STOP_ALPHA_LOOP=1
        return
    fi

    if [ ${#PIPELINE_PIDS[@]} -eq 0 ]; then
        echo "No pipelines left to stop."
        return
    fi

    pid=${PIPELINE_PIDS[0]}
    name=${PIPELINE_NAMES[0]}
    echo ""
    echo "Ctrl+C received: stopping $name (pid $pid)..."
    kill -INT "$pid" 2>/dev/null
    wait "$pid" 2>/dev/null
    PIPELINE_PIDS=("${PIPELINE_PIDS[@]:1}")
    PIPELINE_NAMES=("${PIPELINE_NAMES[@]:1}")

    if [ ${#PIPELINE_PIDS[@]} -eq 0 ]; then
        echo "All pipelines stopped."
    else
        echo "Stopped. ${#PIPELINE_PIDS[@]} pipeline(s) remaining. Next Ctrl+C stops: ${PIPELINE_NAMES[0]}"
    fi
}

# start_pipelines: launches all 5 gst pipelines + the alpha-toggle loop, and
# lets Ctrl+C stop the alpha loop then each pipeline one at a time (in launch
# order). Re-runnable: after everything is stopped, call `start_pipelines`
# again (e.g. from the sourcing shell) to relaunch without repeating the
# overlay/sensor setup steps above.
start_pipelines() {
    PIPELINE_PIDS=()
    PIPELINE_NAMES=()
    STOP_ALPHA_LOOP=0
    trap handle_sigint INT

    echo "Step 10: Launching 8MP pipeline (kmssink plane-id 36)..."
    gst-launch-1.0  v4l2src device=/dev/video8  io-mode=4  ! "video/x-raw, width=3840, height=2160, format=RGB, framerate=30/1" ! queue ! perf name=ISP1_MP_port0  ! kmssink bus-id=b0040000.v_mix  plane-id=36 show-preroll-frame=false -v &
    PIPELINE_PIDS+=($!)
    PIPELINE_NAMES+=("8MP pipeline (video8, plane-id 36)")

    sleep 20

    echo "Step 11: Launching 4 3MP pipelines (kmssink plane-id 38,40,42,44)..."
    gst-launch-1.0  -v v4l2src device=/dev/video0  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port0 !  kmssink bus-id=b0040000.v_mix  plane-id=38 render-rectangle="<0,0,1920,1080>" &
    PIPELINE_PIDS+=($!)
    PIPELINE_NAMES+=("3MP pipeline (video0, plane-id 38)")

    sleep 20

    gst-launch-1.0  -v v4l2src device=/dev/video2  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port1 !  kmssink bus-id=b0040000.v_mix  plane-id=40 render-rectangle="<1920,0,1920,1080>" &
    PIPELINE_PIDS+=($!)
    PIPELINE_NAMES+=("3MP pipeline (video2, plane-id 40)")

    sleep 15

    gst-launch-1.0  -v v4l2src device=/dev/video4  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port2 !  kmssink bus-id=b0040000.v_mix  plane-id=42 render-rectangle="<0,1080,1920,1080>" &
    PIPELINE_PIDS+=($!)
    PIPELINE_NAMES+=("3MP pipeline (video4, plane-id 42)")

    sleep 15

    gst-launch-1.0  -v v4l2src device=/dev/video6  io-mode=4  ! "video/x-raw, width=1920, height=1080, format=RGB, framerate=30/1" ! queue ! perf name=ISP0_MP_port3 !  kmssink bus-id=b0040000.v_mix  plane-id=44 render-rectangle="<1920,1080,1920,1080>" &
    PIPELINE_PIDS+=($!)
    PIPELINE_NAMES+=("3MP pipeline (video6, plane-id 44)")

    echo "All 5 pipelines launched."
    echo "Press Ctrl+C to stop the alpha-toggle loop, then Ctrl+C again to stop each pipeline one at a time (order: ${PIPELINE_NAMES[*]})."

    sleep 10
    while [ "$STOP_ALPHA_LOOP" -eq 0 ]; do
            sleep 30
            [ "$STOP_ALPHA_LOOP" -eq 0 ] || break
	    modetest -D b0040000.v_mix -w 38:alpha:0 && modetest -D b0040000.v_mix -w 40:alpha:0 && modetest -D b0040000.v_mix -w 42:alpha:0 && modetest -D b0040000.v_mix -w 44:alpha:0
            sleep 30
            [ "$STOP_ALPHA_LOOP" -eq 0 ] || break
	    modetest -D b0040000.v_mix -w 38:alpha:256 && modetest -D b0040000.v_mix -w 40:alpha:256 && modetest -D b0040000.v_mix -w 42:alpha:256 && modetest -D b0040000.v_mix -w 44:alpha:256
    done

    echo "Alpha-toggle loop stopped. Press Ctrl+C to stop pipelines one by one (${#PIPELINE_PIDS[@]} remaining)."
    while [ ${#PIPELINE_PIDS[@]} -gt 0 ]; do
        sleep 1
    done

    echo "All pipelines stopped."
    trap - INT
}

start_pipelines
echo "To relaunch all 5 pipelines and the alpha-toggle loop again, run: start_pipelines"
