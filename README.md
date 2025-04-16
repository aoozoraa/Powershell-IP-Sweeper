# Introduction
This is an extremely simple IP Sweeper written in PowerShell that I mostly use in critical Windows Server environments, in which it isn't recommended installing new applications.

What this IP Sweeper does is essencially spam simultaneous pings to all .254 addresses in a specified network, and returns online if the host replies, offline if it doesn't.

Obviously, this does not work as an actual IP Scanner, since it does not check for services, open ports, or connectivity at all. If ICMP fails, it's considered offline. However, it's pretty useful for simple tasks. 
