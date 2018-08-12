portDroid
======
**portDroid** is a small shell script that makes it easy to have systemwide SSH port forwards on Android devices.

## Prerequisites

- A Rooted Android device
- A Bash Binary (Busybox can supply this)
- An SSH Binary (Recommend sshdroid, get it from the playstore [here](https://play.google.com/store/apps/details?id=berserker.android.apps.sshdroid))
- A Public Private Key pair setup with your remote server
- A way to run this script at boot (Recommend smanager, get it from the playstore [here](https://play.google.com/store/apps/details?id=os.tools.scriptmanager))

## Installation

- Place portDroid.sh and .portDroid.cfg in the same directory somewhere on your device.
- Fill out .portDroid.cfg with your configuration

## Usage

- Run it with bash e.g bash **portDroid.sh**
- Note: On first run you will likely be asked to add the server to know hosts.