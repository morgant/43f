INSTALLING 43f
==============

SYSTEM REQUIREMENTS
-------------------

`43f` has been tested on Mac OS X and Linux and requires Bash 3+.

_NOTE:_ On OpenBSD, the [dateutils](http://www.fresse.org/dateutils/) package is required for calculating relative dates. This may become a prerequisite on all platforms in the near future.

BASIC INSTALLATION
------------------

Installation is currently a manual process, but fairly straightforward:

1. Clone the `43f` Git repository:
    
        git clone https://github.com/morgant/43f.git
    
2. Change to the `43f` Git repository directory:
    
        cd 43f
    
3. Install `43f` and the default configuration file into `/usr/local/`:
    
	./configure
        sudo make install
    
4. Edit the newly installed `/usr/local/etc/43f.conf` file to suit your needs
    (esp. the `repository` value which you'll need for the next step).
5. Initialize the `43f` repository (replacing `/path/to/repository` with the
    path to the directory where you would like `43f` to store & manage files):
    
        43f init /path/to/repository
    
6. If you will use `launchd` to run `43f`'s nightly storage management process
    (highly suggested):
    
        sudo launchctl load /Library/LaunchDaemons/com.makkintosshu.43f.plist
    
    Otherwise, if you prefer to use cron, then edit your preferred crontab
    (replacing `username` with the name of the user who you'd like `43f` to be
    run by):
    
        sudo crontab -u username -e
    
    And pasting in the following:
    
        0 0 * * * /usr/local/bin/43f run
    
7. That should do it. You should now be able to start storing files and/or
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
