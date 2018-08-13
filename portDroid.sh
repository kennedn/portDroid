#!/system/xbin/bash

# Check we are the only instance running
if [ "$(pgrep -fc "$0")" -gt "1" ]; then
	echo "$0 already running"
	exit 1
fi

# Source the Config File
. $(dirname "$0")/.portDroid.cfg

### Start SSH Command construction
SSHCOMMAND="$SSHBIN -i $PRIVKEY -f -N -p $PORT"

for pf in "${PORTFORWARDS[@]}"; do
	SSHCOMMAND="$SSHCOMMAND -L ${pf}"
done
SSHCOMMAND="$SSHCOMMAND ${USERNAME}@${SERVERADDR} &> /dev/null"
### End Construction

# Kill all running ssh processes if there are any
function killSSH {
        for pid in $(pgrep -f "$PRIVKEY"); do  
                kill -9 "$pid" 2> /dev/null
                echo "$pid Killed"
        done             
}
killSSH

#Cleanup function for when the script gets killed/dies
function cleanUp {
	killSSH
	exit 0
}
trap cleanUp SIGINT SIGTERM


# Test if VPN tunnel is active
ifconfig "$VPNDEVNAME" > /dev/null 2>&1
isTun="$?"

while true; do
	
	# Kill SSH if the state of the VPN has changed	 
	ifconfig "$VPNDEVNAME" > /dev/null 2>&1
	rt="$?"
	if [ "${rt}" != "${isTun}" ]; then
		isTun=${rt}
		killSSH
		echo "VPN State Changed"
	fi

	# If ssh is not running
	if ! pgrep -f "$PRIVKEY" > /dev/null 2>&1 ; then
		echo "SSH is not running"

		#If we have an internet connection
		if ping -c 1 "$PINGADDR" > /dev/null 2>&1; then
			echo "We Have a ping"
			$SSHCOMMAND && echo "Connection established" 
		fi
	fi
	sleep "$TIMER"
done
exit 0

