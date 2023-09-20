SHELL:= /bin/bash
# First, change the terminal in makefile from shell type to bash type
backupdirfound: backupdirgen
	@./backupd.sh dir backupdir 3 4

# after first check in backupdirgen, go to backupdirfound and \
 run backupd.sh with arguments of choice \
filename directory backupDirectory intervals-sec no.Backups

backupdirgen:
	@if ! [ -d "backupdir" ]; then \
		mkdir ./backupdir; \
	fi

# then first we go to backupdurgen, create backupdir directory if it isn't made