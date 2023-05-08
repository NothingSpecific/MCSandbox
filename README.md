# MCSandbox
A Minecraft sandbox script written to work as a Prism Launcher wrapper command.

Usage is simple. Just add this script as a Prism Launcher wrapper command either in the launcher's global settings, or in the settings for the specific instance you plan to use this with.

Optionally you can install `mcsandbox.sh` into your system's `$PATH`.

This script should work by default without adding any options to the command-line. Note that it does not do any X11 sandboxing, so X11-based attacks are still possible unless you use Wayland. I'm comfortable with this since X11 keylogging and screen grabbing are purely passive attacks. As long as you don't type anything sensitive while Minecraft is open, you shouldn't have to worry about these. Note that some attacks may try to fake keystrokes to interact with the system, but these attacks are trivial to spot by watching the system (unless you leave the system unattended you're going to know if a terminal randomly opens up).

To improve system compatibility and make my life easier, this script gives full read-only access to the filesystem, except for `/home`. This script trusts that your system's filesystem permissions are properly configured to deny read access to anything too sensitive.
