#!/bin/bash

# Start virtual display
/usr/bin/Xvfb :0 -screen 0 1280x800x24 &

# Give Xvfb time to start
sleep 2

# Start x11vnc
/usr/bin/x11vnc -display :0 -rfbport 5900 -forever -shared -nopw &

# Start noVNC (websockify)
/usr/bin/websockify --web=/usr/share/novnc/ 0.0.0.0:6080 localhost:5900
