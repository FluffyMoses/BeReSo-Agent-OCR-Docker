# BeReSo-Agent-OCR-Docker
Agent to convert images into encoded text for the BeReSo webapp.

A Docker image is build with the needed software to run the agent script.

<a href="https://github.com/FluffyMoses/BeReSo">BeReSo on GitHub</a>

### Install and run Container

At first you have to enable OCR and set a strong OCR agent password in your BeReSo admincenter.

Then get the container from Dockerhub, configure and run the agent.

<b>Environment variables:</b>
```
BERESO_PASSWORD - the password you choose in the BeReSo admincenter
BERSO_URL - the URL of the BeReSo installation
INTERVAL - time between checks for new images
LANGUAGE - Language used by tesseract - installed in this docker image: eng, deu
```

<b>Run the container:</b>
```
# BeReSo-Agent-OCR
docker run \
-d \
--name bereso_docker_ocr \
--restart=unless-stopped \
-e "TZ=Europe/Berlin" \
-e 'BERESO_PASSWORD=PASSWORD_FOR_OCR_AGENT' \
-e 'BERESO_URL=http://bereso/' \ 
-e 'INTERVAL=3600' \
-e 'LANGUAGE=eng' \ 
fluffymoses/bereso-agent-ocr
```
