This file handles the fingerprnt authentication for hyprlock/system.
It is placed in /etc/pam.d directory for it to work.
The default behavior is that if fingerprnt authentication is activated then
the system waits for fingerprint first and only then it asks for password. Therefore
if you use password first, you will have to wait for sometime before your system
unlocks.
This hyprlock config solves this issue and system unlocks irrespective of method
of unlock, i.e. fingerprint or password.

p.s: clearly it is useless if your system doesn't support fingerprnt authentication
