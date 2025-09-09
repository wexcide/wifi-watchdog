# wifi-watchdog
A systemd script to monitor wifi connections and auto cycle the adapter on failure.

For those of us that are plagued by Realtek Wireless NICs (RTL8852BE in my case) intermittently failing to process network traffic in various Linux distros, this script will utilize systemd timers to monitor the connection and reset it if necessary. By default, it checks and logs every 2 minutes. Feel free to adjust as necessary and disable logging if desired. I would consider disabling logging once you know it is working by commenting out log lines in wifi-watchdog.sh but it is entirely up to you and how much you want to log vs how much disk space you have.

*Note: This script was written and tested on Ubuntu 24.04.3, taking advantage of nmcli, your results may vary and may require tweaking for your personal choice in network management. I will add various spins of it eventually, but for now this meets my needs and can hopefully help you. In theory it will should work 100% on any distro using systemd and nmcli (Ex: Fedora).

If you have suggestions on how to improve it, I am all ears. I am by no means an expert and am just sharing my tricks.

<b><u>If you encounter any bugs, please report them! While this is more a personal endeavor, if it helps someone else out, I would love to better the script!</b></u>

# Automatic Installation (Tested on Ubuntu 24.04.3)

Always use caution when bashing from a link in general, please feel free to read my script beforehand to see that it is safe:

<code>sudo bash -c "$(wget https://raw.githubusercontent.com/wexcide/wifi-watchdog/main/setup-wifi-watchdog.sh -O -)"</code>

# Getting Started Manually
### Create a shell script to house the watchdog:
<code> sudo nano /usr/local/bin/wifi-watchdog.sh </code>

Insert contents of wifi-watchdog.sh from this repo.

Save with Ctrl+X, Y, Enter

### Create a service file for the watchdog:
<code> sudo nano /etc/systemd/system/wifi-watchdog.service </code>

Insert contents of wifi-watchdog.service from this repo.


Save with Ctrl+X, Y, Enter

### Create a timer file to execute the watchdog:
<code> sudo nano /etc/systemd/system/wifi-watchdog.timer </code>

Insert contents of wifi-watchdog.timer from this repo.

Save with Ctrl+X, Y, Enter

### Eable the watchdog:
<code>sudo systemctl daemon-reload</code></br>
<code>sudo systemctl enable --now wifi-watchdog.timer</code>

### Optional: Force run the service out of timer cycle:
<code> sudo systemctl start wifi-watchdog.service </code>

### Optional: View the logs:
<code> cat /var/log/wifi-watchdog.log </code></br>
<code> journalctl -u wifi-watchdog.service --no-pager </code>
