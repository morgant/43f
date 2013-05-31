INSTALLING 43f
==============

BASIC INSTALLATION
------------------

Installation is currently a manual process, but fairly straightforward:

1. Clone the `43f` Git repository:
    
        git clone https://github.com/morgant/43f.git
    
2. Change to the `43f` Git repository directory:
    
        cd 43f
    
3. Install the `43f` script into `/usr/local/bin`:
    
        sudo mkdir -p /usr/local/bin
        sudo install -b 43f /usr/local/bin/
    
4. Copy the default configuration file into `/usr/local/etc/`:
    
        sudo mkdir -p /usr/local/etc
        sudo cp 43f.conf.default /usr/local/etc/43f.conf
    
5. Edit the newly installed `/usr/local/etc/43f.conf` file to suit your needs
    (esp. the `repository` value which you'll need for the next step).
6. Initialize the `43f` repository (replacing `/path/to/repository` with the
    path to the directory where you would like `43f` to store & manage files):
    
        43f init /path/to/repository
    
7. If you will use `launchd` to run `43f`'s nightly storage management process
    (highly suggested):
    
        sudo cp com.makkintosshu.43f.plist.default /Library/LaunchDaemons/com.makkintosshu.43f.plist
        sudo launchctl load /Library/LaunchDaemons/com.makkintosshu.43f.plist
    
    Otherwise, if you prefer to use cron, then edit your preferred crontab
    (replacing `username` with the name of the user who you'd like `43f` to be
    run by):
    
        sudo crontab -u username -e
    
    And pasting in the following:
    
        0 0 * * * /usr/local/bin/43f run
    
8. That should do it. You should now be able to start storing files and/or
    directories in the daily and/or monthly directories within your `43f` 
    repository file structure (there are even `today`, `yesterday`, `sunday`,
    `monday`, `tuesday`, `wednesday`, `thursday`, `friday`, and `saturday` 
    symlinks for your convenience).


ADVANCED INSTALLATION
---------------------

If you would like to install the `43f` configuration in a different location
than the default of `/usr/local/etc`, you may do so, but will need to modify
either the `com.makkintosshu.43f.plist` file or the line in your `crontab` 
(Step 7 in the "BASIC INSTALLATION" instructions) to explicitly specify the 
configuration file with the `-c` option, for example:

    /usr/local/bin/43f -c /path/to/config/43f.conf run

Please note that, if using `launchd`, the `launchd.plist` syntax requires that 
each argument be specified in a different string in the `ProgramArguments` 
dictionary, so:

    <key>ProgramArguments</key>
    <array> 
        <string>/usr/local/bin/43f</string>
        <string>run</string>
    </array>

Would need to become:

    <key>ProgramArguments</key>
    <array> 
        <string>/usr/local/bin/43f</string>
        <string>-c</string>
        <string>/path/to/config/43f.conf</string>
        <string>run</string>
    </array>
