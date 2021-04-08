FROM debian:10

ENV DEBIAN_FRONTEND=noninteractive

# Install Nginx, php and all needed php modules 
RUN apt-get update \
  && apt-get install -y tesseract-ocr tesseract-ocr-deu curl imagemagick locales

# Create dirs
RUN mkdir /bereso_agent_ocr

# Copy BeReSo_Agent_OCR script
COPY bereso_agent_ocr.sh /bereso_agent_ocr/
RUN chmod +x /bereso_agent_ocr/bereso_agent_ocr.sh

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Entrypoint script
ENTRYPOINT ["entrypoint.sh"]
