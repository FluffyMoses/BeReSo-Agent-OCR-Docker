#!/bin/bash

# Run endless and start the bereso_agent_ocr script every $INTERVAL seconds

echo "BeReSo installation: $BERESO_URL"
echo "Check every $INTERVAL seconds"
echo "Tesseract Language: $LANGUAGE"

while true;
do
	# Start the agent
	echo "Connecting to BeReSo installation: $BERESO_URL"
	/bereso_agent_ocr/bereso_agent_ocr.sh 
	echo "Waiting $INTERVAL seconds..."

	# sleep for $INTERVAL seconds
	sleep $INTERVAL;
done