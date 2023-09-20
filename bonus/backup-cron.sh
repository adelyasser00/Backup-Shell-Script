#!/bin/bash

#First, check that the arguments are input validated
if ! [ -d $1 ]
then
    echo "directory does not exist!"
    exit 1
    #create backup directory if there isn't any
elif ! [ -d $2 ]
then
    mkdir $2
elif ! [[ $3 =~ [0-9] ]]
then    
    echo "max-backups must be a number (third argument)"
    exit 1
fi
#if last directory info doesn't exist (first time), create it and make first backup
#directory info logs stored in current path var to support multiple systems absolute paths
curr_path="lab2/bonus"
if ! [[ -e $curr_path/directory-info.last ]]
then   
    ls -lR $1> $curr_path/directory-info.last
    #obtain current date in format: YYYY-MM-DD-HH-MM-SS for backup directory names
    curr_date=$(date +"%Y-%m-%d-%H-%M-%S")
    #copy recursively the initial backup to a folder named with the time of backup created
    mkdir $2/$curr_date
    cp -r $1/* $2/$curr_date/
    #count number of backups by counting number of directories in it by word count by line -l
    echo "Current Backup count=" $(ls $2 | wc -l)
else
    #else not first time, check current status and act accordingly
    #create current directory info file and save to directory-info.new
    ls -lR $1> lab2/bonus/directory-info.new
    echo $(cmp -s directory-info.last directory-info.new)
    #compare current directory info to last directory info saved
    if cmp -s $curr_path/directory-info.last $curr_path/directory-info.new
    then
        echo "No changes happened." "Current Backup count=" $(ls $2 | wc -l)
    else
        #first, check if maximum number of backups reached
        #if reached, replace oldest backup with newest to keep the most recent 
        #max-backups number of directory in backupdir
        if (($(ls $2 | wc -l) == $3))
        then
        echo $(ls $2 | wc -l)
            # use ls to get all backup directory names (due to our file naming by 
            # being dates, oldest directory is always the first one in the ls string)
            # pick the first line by using head by n lines 1,
            # cut the string by field 1 to get first and oldest directory name
            # remove the oldest directory recursively and f ignoring any ask to delete
            rm -rf $2/$(ls $2 | head -n 1 | cut -f 1) 
            echo "Reached maximum backups! Replacing oldest backup with newest one!"
        fi
        #changes have been made, create a new backup with current time and current changes
        curr_date=$(date +"%Y-%m-%d-%H-%M-%S")
        mkdir $2/$curr_date
        cp -r $1/* $2/$curr_date
        echo "Current Backup count=" $(ls $2 | wc -l)
        #finally, update the last directory info with the current one
        cp $curr_path/directory-info.new $curr_path/directory-info.last
    fi
fi