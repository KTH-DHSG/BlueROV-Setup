#!/bin/bash
x11vnc -display :0 -rfbport 5900 -forever -shared -nopw
websockify --web=/usr/share/novnc/ 0.0.0.0:6080 localhost:5900
