#!/bin/bash

XPRA_DISPLAY=0

# Xpra commented out due to issues with performance and mouse handling
# Perhaps using a different X server might solve the issues, but so far I'm too lazy and
# I think anything more than screen/clipboard grabbing would be detected by the user
# allowing the opportunity to interrupt the attack

#XPRA_DISPLAY="$RANDOM"
#xpra start :"$XPRA_DISPLAY"
#while :; do
#	[[ -e /tmp/.X11-unix/X"$XPRA_DISPLAY" ]] && break
#	echo "Waiting for xpra display $XPRA_DISPLAY"
#	sleep 1
#done
#xpra attach :"$XPRA_DISPLAY" &

echo "Command to be sandboxed:"
echo "$@"

declare -a EXTRA_OPTS=()
declare -a COMMAND=()

for i in "$@"; do
	if [[ "$i" == "--full-launcher-access" ]]; then	# Not recommended. A malicious instance with full launcher access can
							# escape the sandbox by rewriting the launcher's configuration
							# to run malicious code outside of the sandbox
		EXTRA_OPTS+=(--bind ~/.local/share/PrismLauncher/ ~/.local/share/PrismLauncher/)
	elif [[ "$i" == "--libs" ]]; then	# Some mods need library access in order to work properly
						# Usually this is only necessary on the first launch and subsequent
						# attempts to start the game can be fully restricted
		EXTRA_OPTS+=(--bind ~/.local/share/PrismLauncher/libraries/ ~/.local/share/PrismLauncher/libraries/)
	else
		COMMAND+=("$i")
	fi
done

# Set environment variables
export WURST_OPENAI_KEY='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'

# This command was written for X11 and has not been tested on Wayland
CMD=(bwrap --ro-bind / / --tmpfs /var/tmp --tmpfs /home/ --tmpfs /tmp \
	--bind /tmp/.X11-unix/X"$XPRA_DISPLAY" /tmp/.X11-unix/X"$XPRA_DISPLAY" --setenv DISPLAY :"$XPRA_DISPLAY" \
	--ro-bind ~/.Xauthority ~/.Xauthority \
	--unshare-all --share-net --new-session --cap-drop ALL --die-with-parent \
	--dev-bind /dev/ /dev/ --proc /proc --ro-bind ~/.local/share/PrismLauncher/ ~/.local/share/PrismLauncher/ --bind "$INST_DIR" "$INST_DIR" \
	--bind-try "$XDG_RUNTIME_DIR/pipewire-0" "$XDG_RUNTIME_DIR/pipewire-0" \
	--bind "$XDG_RUNTIME_DIR/pulse" "$XDG_RUNTIME_DIR/pulse" "${EXTRA_OPTS[@]}" \
	"${COMMAND[@]}")

echo "Command to start sandbox:"
echo "${CMD[@]}"
echo "----------------------------"

# Start sandbox
"${CMD[@]}"

# Cleanup Xpra server
#xpra stop :"$XPRA_DISPLAY"
