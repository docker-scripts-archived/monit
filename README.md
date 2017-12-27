# Monit in a Container

## Installation

  - First install `ds`: https://github.com/docker-scripts/ds#installation

  - Then get the scripts from github: `ds pull monit`

  - Create a directory for the container: `ds init monit @monit`

  - Fix the settings: `cd /var/ds/monit/ ; vim settings.sh`

  - Build image, create the container and configure it: `ds make`

  - Add to wsproxy: `ds wsproxy add; ds wsproxy ssl-cert`

  - Change conf.d and restart: `ds restart`
