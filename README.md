# Operating Systems Lab 1
##### Developed by Adel Yasser 6848
## Overview
This linux bash script is developed to backup any given directory to a backup directory of choice using a time interval of choice and maximum number of backups desired. 
### Code
This code uses a bash script .sh file and a makefile to run the file by using command "make" in terminal.

The makefile first checks if the backup directory "backupdir" exists and creates it if not.
Then, the makefile runs the the backupd.sh script to start the backup process.
Please modify the arguments in the line calling the backupd.sh to obtain your desired output
(file) (original-directory) (backup-directory) (intervals-sec) (max-backups)

The backupd.sh backup script starts by validating input parameters.
It clears the backup directory for the desired maximum backups.
It gets original directory information and stores it in directory-info.last.
It performs the initial backup for the directory in a directory named as the time of the backup. Then loops forever checking if any changes happened.
If any change happened the script will create a new backup. If we reach the maximum backups inserted. the script will update the backup folder to keep the most recent maximum backup folders.

The main project folder contains the dir, backupdir (any other directories can be selected by changing makefile argument), backupd.sh, makefile, directory-info.last, directory-info.new, and README.md (as well as the bonus cron job part).

### Prerequisites
This script requires an ubuntu linux bash script interface to work. You can either use ubuntu linux OS or you could install wsl on a windows OS machine.
Please change the mode of the file by opening the terminal in the folder and typing chmod +x backupd.sh

### Instructions
Open the terminal in the project directory by right-click, select open in terminal on Ubuntu or type in wsl in address bar for windows
open the makefile and modify the arguments if needed
In terminal, type make and press enter
every interval-secs time, if there is a new change. the backup folder will have a new update directory with the most recent changes.

# Bonus
## Cron job update
In the project folder. open the bonus folder to access.
Linux based system is required!

### How to Configure
#### Prerequisites
Add access to your user to use cron jobs by opening terminal and typing:
sudo cat cron.allow (username)
Check the cron service by typing:
sudo systemct1 status cron.service
use "crontab -l" to view all current cron services on this user.
#### how to run
to add cron service. first in the backup-cron.sh the script has three arguments since the max-intervals is handled by cron service.
(filename) dir backupdir max-backups
<bold>All paths when handling cron scripts must have absolute paths originating from home directory</bold>

Open the backup-cron.sh and update the absolute paths for the directory-info.last and directory-info.new to fit the project.

Open terminal and type crontab -e and choose the nano editor
the parameters for cron jobs are
minutes hours days weeks months weekdays (filename path) (arguments)
To run the cron job running our script every minute, type in
"* * * * * (filename) dir backupdir max-backups"
then Ctrl+o Enter Ctrl+x
Enjoy the backup service using the cron service.

#### question c run the service on 3rd friday of every month
31 0 15-21 * 5 (Absolute path)backup-cron.sh dir backupdir max-backups