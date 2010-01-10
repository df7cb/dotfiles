#!/bin/sh

set -e

DIR=$(mktemp -d -t pluckerXXXXXX)
trap "rm -rf $DIR" 0 2 3 15

cat > $DIR/map.viking <<EOF
#VIKING GPS Data file http://viking.sf.net/

xmpp=4,000000
ympp=4,000000
lat=51,432107
lon=6,795948
mode=mercator
color=#cccccc
drawscale=t
drawcentermark=t
~Layer Map
name=Karte
mode=13
directory=
alpha=255
autodownload=t
mapzoom=0
~EndLayer
EOF

cat > $DIR/gps.viking <<EOF
#VIKING GPS Data file http://viking.sf.net/

xmpp=4,000000
ympp=4,000000
lat=51,432107
lon=6,795948
mode=mercator
color=#cccccc
drawscale=t
drawcentermark=t
~Layer GPS
name=GPS
gps_protocol=0
gps_port=2
record_tracking=t
center_start_tracking=t
gpsd_host=localhost
gpsd_port=2947

~Layer TrackWaypoint
name=TrackWaypoint
tracks_visible=t
waypoints_visible=t
drawmode=0
drawlines=t
drawpoints=t
drawelevation=f
elevation_factor=30
drawstops=f
stop_length=60
line_thickness=1
bg_line_thickness=0
trackbgcolor=#ffffff
velocity_min=0.000000
velocity_max=5.000000
drawlabels=t
wpcolor=#000000
wptextcolor=#ffffff
wpbgcolor=#8383c4
wpbgand=t
wpsymbol=0
wpsize=4
wpsyms=t
drawimages=t
image_size=64
image_alpha=255
image_cache_size=300


~LayerData
type="waypointlist"
type="waypointlistend"
~EndLayerData
~EndLayer


~Layer TrackWaypoint
name=TrackWaypoint
tracks_visible=t
waypoints_visible=t
drawmode=0
drawlines=t
drawpoints=t
drawelevation=f
elevation_factor=30
drawstops=f
stop_length=60
line_thickness=1
bg_line_thickness=0
trackbgcolor=#ffffff
velocity_min=0.000000
velocity_max=5.000000
drawlabels=t
wpcolor=#000000
wptextcolor=#ffffff
wpbgcolor=#8383c4
wpbgand=t
wpsymbol=0
wpsize=4
wpsyms=t
drawimages=t
image_size=64
image_alpha=255
image_cache_size=300


~LayerData
type="waypointlist"
type="waypointlistend"
~EndLayerData
~EndLayer


~Layer TrackWaypoint
name=TrackWaypoint
tracks_visible=t
waypoints_visible=t
drawmode=0
drawlines=t
drawpoints=t
drawelevation=f
elevation_factor=30
drawstops=f
stop_length=60
line_thickness=1
bg_line_thickness=0
trackbgcolor=#ffffff
velocity_min=0.000000
velocity_max=5.000000
drawlabels=t
wpcolor=#000000
wptextcolor=#ffffff
wpbgcolor=#8383c4
wpbgand=t
wpsymbol=0
wpsize=4
wpsyms=t
drawimages=t
image_size=64
image_alpha=255
image_cache_size=300


~LayerData
type="waypointlist"
type="waypointlistend"
~EndLayerData
~EndLayer

~EndLayer
EOF

viking $DIR/map.viking "$@" $DIR/gps.viking
