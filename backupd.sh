#!/bin/bash

#First, check that the arguments are input validated
if ! [ -d $1 ]
then
    echo "directory does not exist!"
    exit 1

elif ! [ -d $2 ]
then
    echo "backup directory does not exist!"
    exit 1
elif ! [[ $3 =~ [0-9] ]]
then    
    echo "intervals-sec must be a number (third argument)"
    exit 1
elif ! [[ $4 =~ [0-9] ]]
then    
    echo "max-backups must be an integer (fourth argument)"
    exit 1
fi
# first clear backupdir directory if not empty to maintain max-backups
rm -rf backupdir/*
#make initial directory info file and save to directory-info.last
#store output of ls that includes -l long list format and -R include subdirectories
ls -lR $1> directory-info.last
#obtain current date in format: YYYY-MM-DD-HH-MM-SS for backup directory names
curr_date=$(date +"%Y-%m-%d-%H-%M-%S")
#copy recursively the initial backup to a folder named with the time of backup created
mkdir $2/$curr_date
cp -r $1/* $2/$curr_date/
backup_count=1
echo "Current Backup count=" $backup_count
#run forever, until user stops script by ctrl+c
while true
do
    #first, wait interval-secs time before checking for changes
    sleep $3
    #then, create current directory info file and save to directory-info.new
    ls -lR $1> directory-info.new
    #compare current directory info to last directory info saved
    if cmp -s directory-info.last directory-info.new
    then
        echo "No changes happened." "Current Backup count=" $backup_count
    else
        #first, check if maximum number of backups reached
        #if reached, replace oldest backup with newest to keep the most recent 
        #max-backups number of directory in backupdir
        if ((backup_count == $4))
        then
            # use ls to get all backup directory names (due to our file naming by 
            # being dates, oldest directory is always the first one in the ls string)
            # pick the first line by using head by n lines 1,
            # cut the string by field 1 to get first and oldest directory name
            # remove the oldest directory recursively and f ignoring any ask to delete
            rm -rf $2/$(ls $2 | head -n 1 | cut -f 1) 
            ((backup_count--))
            echo "Reached maximum backups! Replacing oldest backup with newest one!"
        fi
        #changes have been made, create a new backup with current time and current changes
        curr_date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir $2/$curr_date
        cp -r $1/* $2/$curr_date
        ((backup_count++))
        echo "Current Backup count=" $backup_count
        #finally, update the last directory info with the current one
        cp directory-info.new directory-info.last
    fi
done        
