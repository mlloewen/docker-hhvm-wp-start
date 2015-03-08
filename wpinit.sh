#!/bin/bash
cd /data/src/html/wordpress/wp-content/plugins
if [ ! -f /data/src/html/wordpress/wp-content/plugins/revisr/readme.txt ]; then
	git clone https://github.com/ExpandedFronts/Revisr.git
