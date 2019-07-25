#!/bin/bash

set -euo pipefail

curl --silent \
     --show-error \
     --location \
     --fail \
     --retry 3 \
     --output /tmp/chromedriver_linux64.zip \
     https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip

unzip -o /tmp/chromedriver_linux64.zip chromedriver -d /usr/local/bin

rm /tmp/chromedriver_linux64.zip

chromedriver --version
