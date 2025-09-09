# wifi-watchdog
A systemd script to monitor wifi connections and auto cycle the adapter on failure.

For those of us that are plagued by Realtek Wireless NICs (RTL8852BE in my case) intermittently failing to process network traffic in various Linux distros, this script will utilize systemd timers to monitor the connection and reset it if necessary.

*Note: This script was written and tested on Ubuntu 24.04.3, taking advantage of nmcli, your results may vary and may require tweaking for your personal choice in network management. I will add various spins of it eventually, but for now this meets my needs and can hopefully help you.
