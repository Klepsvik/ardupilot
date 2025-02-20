#!/bin/bash

set -e
set -x

PARAMS_DIR="../buildlogs/Parameters"

# work from either APM directory or above
[ -d ArduPlane ] || cd APM

/bin/mkdir -p "$PARAMS_DIR"

generate_parameters() {
    VEHICLE="$1"

    # generate Parameters.html, Parameters.rst etc etc:
    ./Tools/autotest/param_metadata/param_parse.py --vehicle $VEHICLE

    # stash some of the results away:
    VEHICLE_PARAMS_DIR="$PARAMS_DIR/$VEHICLE"
    mkdir -p "$VEHICLE_PARAMS_DIR"
    /bin/cp Parameters.html *.pdef.xml "$VEHICLE_PARAMS_DIR/"
    gzip -9 <"$VEHICLE_PARAMS_DIR"/apm.pdef.xml >"$VEHICLE_PARAMS_DIR"/apm.pdef.xml.gz.new && mv "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.gz.new "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.gz
    xz -e <"$VEHICLE_PARAMS_DIR"/apm.pdef.xml >"$VEHICLE_PARAMS_DIR"/apm.pdef.xml.xz.new && mv "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.xz.new "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.xz
    if [ -e "Parameters.rst" ]; then
	/bin/cp Parameters.rst "$VEHICLE_PARAMS_DIR/"
    fi
}

generate_sitl_parameters() {
    VEHICLE="ArduCopter"

    # generate Parameters.html, Parameters.rst etc etc:
    ./Tools/autotest/param_metadata/param_parse.py --sitl --vehicle $VEHICLE

    # stash some of the results away:
    VEHICLE_PARAMS_DIR="$PARAMS_DIR/SITL"
    mkdir -p "$VEHICLE_PARAMS_DIR"
    /bin/cp Parameters.html *.pdef.xml "$VEHICLE_PARAMS_DIR/"
    gzip -9 <"$VEHICLE_PARAMS_DIR"/apm.pdef.xml >"$VEHICLE_PARAMS_DIR"/apm.pdef.xml.gz.new && mv "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.gz.new "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.gz
    xz -e <"$VEHICLE_PARAMS_DIR"/apm.pdef.xml >"$VEHICLE_PARAMS_DIR"/apm.pdef.xml.xz.new && mv "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.xz.new "$VEHICLE_PARAMS_DIR"/apm.pdef.xml.xz
    if [ -e "Parameters.rst" ]; then
	/bin/cp Parameters.rst "$VEHICLE_PARAMS_DIR/"
    fi
}

generate_parameters ArduPlane

generate_parameters ArduCopter

generate_parameters Rover

generate_parameters ArduSub

generate_parameters AntennaTracker

generate_sitl_parameters
